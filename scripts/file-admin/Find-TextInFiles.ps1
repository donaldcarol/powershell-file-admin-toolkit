<#
.SYNOPSIS
Search for text patterns inside files.

.DESCRIPTION
Searches recursively through files and returns matching lines.
Supports filtering by file extension, case-sensitive search, and CSV export.

.EXAMPLE
.\Find-TextInFiles.ps1 -Path "C:\Logs" -Pattern "error","failed" -Extension "log","txt"

.EXAMPLE
.\Find-TextInFiles.ps1 -Path "C:\Logs" -Pattern "Access denied" -CaseSensitive
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) { $true }
        else { throw "Path does not exist or is not a folder: $_" }
    })]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [string[]]$Pattern,

    [string[]]$Extension = @(),

    [switch]$CaseSensitive,

    [switch]$IncludeHidden,

    [string]$ExportCsv = ".\reports\text-search-report.csv"
)

$ErrorActionPreference = "Stop"

try {
    Write-Host "Searching in: $Path"
    Write-Host "Patterns: $($Pattern -join ', ')"

    $files = Get-ChildItem -Path $Path -File -Recurse -Force:$IncludeHidden

    if ($Extension.Count -gt 0) {
        $cleanExtensions = $Extension | ForEach-Object {
            $_.TrimStart(".")
        }

        $files = $files | Where-Object {
            $_.Extension.TrimStart(".") -in $cleanExtensions
        }
    }

    $selectStringParams = @{
        Pattern = $Pattern
    }

    if ($CaseSensitive) {
        $selectStringParams.CaseSensitive = $true
    }

    $matches = $files | Select-String @selectStringParams

    $results = $matches | Select-Object `
        @{Name="FileName";Expression={ Split-Path $_.Path -Leaf }},
        Path,
        LineNumber,
        Line,
        Pattern

    $results |
        Sort-Object Path, LineNumber |
        Export-Csv -Path $ExportCsv -NoTypeInformation

    Write-Host "Matches found: $($results.Count)"
    Write-Host "Report exported to: $ExportCsv"

    $results
}
catch {
    Write-Error "Script failed: $($_.Exception.Message)"
}
