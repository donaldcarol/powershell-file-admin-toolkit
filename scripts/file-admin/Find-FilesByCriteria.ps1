<#
.SYNOPSIS
Find files based on name patterns, extensions, size, and creation date range.

.DESCRIPTION
Searches recursively for files matching one or more criteria:
- Name contains text
- File extension
- Minimum file size
- Creation date interval

Exports results to CSV.

.EXAMPLE
.\Find-FilesByCriteria.ps1 `
-Path "M:\films" `
-NameContains "watch" `
-Extension "mkv","mp4" `
-MinSizeMB 100 `
-CreatedAfter "2024-01-01" `
-CreatedBefore "2024-12-31"
#>

[CmdletBinding()]
param(

    [Parameter(Mandatory)]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) {
            $true
        }
        else {
            throw "Folder not found"
        }
    })]
    [string]$Path,

    [string]$NameContains,

    [string[]]$Extension,

    [int]$MinSizeMB = 0,

    [datetime]$CreatedAfter,

    [datetime]$CreatedBefore,

    [switch]$IncludeHidden,

    [string]$ExportCsv = ".\reports\file-search-report.csv"
)

$ErrorActionPreference = "Stop"

try {
    Write-Host "Scanning: $Path"

    $files = Get-ChildItem `
        -Path $Path `
        -File `
        -Recurse `
        -Force:$IncludeHidden

    # Filter by name
    if ($NameContains) {
        $files = $files | Where-Object {
            $_.Name -like "*$NameContains*"
        }
    }

    # Filter by extension
    if ($Extension) {
        $cleanExtensions = $Extension | ForEach-Object {
            $_.TrimStart(".")
        }

        $files = $files | Where-Object {
            $_.Extension.TrimStart(".") -in $cleanExtensions
        }
    }

    # Filter by minimum size
    if ($MinSizeMB -gt 0) {
        $files = $files | Where-Object {
            $_.Length -gt ($MinSizeMB * 1MB)
        }
    }

    # Filter by creation date lower bound
    if ($CreatedAfter) {
        $files = $files | Where-Object {
            $_.CreationTime -ge $CreatedAfter
        }
    }

    # Filter by creation date upper bound
    if ($CreatedBefore) {
        $files = $files | Where-Object {
            $_.CreationTime -le $CreatedBefore
        }
    }

  $results = $files |
Sort-Object LastWriteTime -Descending |
Select-Object `
@{
    Name="File Name"
    Expression={$_.Name}
},

@{
    Name="Modified"
    Expression={$_.LastWriteTime}
}

    $csvFolder = Split-Path $ExportCsv -Parent
    if ($csvFolder -and -not (Test-Path $csvFolder)) {
        New-Item -Path $csvFolder -ItemType Directory -Force | Out-Null
    }

  $results |
Format-Table -AutoSize

$results |
Export-Csv `
-Path $ExportCsv `
-NoTypeInformation

    Write-Host "Found: $($results.Count) files"
    Write-Host "Report exported to: $ExportCsv"

    $results
}
catch {
    Write-Error "Script failed: $($_.Exception.Message)"
}
