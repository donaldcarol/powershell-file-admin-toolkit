<#
.SYNOPSIS
Count files recursively while excluding specific folders.

.DESCRIPTION
This script counts files under a given root path, while excluding folders
by name pattern such as "_*", ".git", "node_modules", etc.

It is useful when you want to count real project files while ignoring
temporary, hidden, generated, or repository-related folders.

.EXAMPLE
.\Count-FilesExcludingFolders.ps1 -Path "G:\lab"

.EXAMPLE
.\Count-FilesExcludingFolders.ps1 -Path "G:\lab" -ExcludeFolder "_*", ".git", "node_modules"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) { $true }
        else { throw "Path does not exist or is not a folder: $_" }
    })]
    [string]$Path,

    [string[]]$ExcludeFolder = @(),

    [string[]]$ExcludeExtension = @(),
    
    [switch]$IncludeHidden,

    [string]$ExportCsv
)

$ErrorActionPreference = "Stop"

try {
    Write-Host "Scanning path: $Path"
    Write-Host "Excluded folders: $($ExcludeFolder -join ', ')"

    $gciParams = @{
        Path      = $Path
        Directory = $true
        Recurse   = $true
    }

    if ($IncludeHidden) {
        $gciParams.Force = $true
    }

    # Get all directories except excluded ones
   $resolvedExclusions = foreach ($exclude in $ExcludeFolder) {
    if (Test-Path $exclude -PathType Container) {
        (Resolve-Path $exclude).Path.TrimEnd('\')
    }
    else {
        $exclude
    }
}

$dirs = Get-ChildItem @gciParams | Where-Object {
    $dir = $_
    $dirFullName = $dir.FullName.TrimEnd('\')

    -not (
        $resolvedExclusions | Where-Object {
            if ($_ -match '^[a-zA-Z]:\\') {
                $dirFullName -like "$_*"
            }
            else {
                $dir.Name -like $_
            }
        }
    )
}

    # Include root folder itself
    $allDirs = @((Get-Item $Path)) + $dirs


$files = Get-ChildItem -Path $Path -File -Recurse -Force:$IncludeHidden

foreach ($exclude in $ExcludeFolder) {

    # Full path exclusion
    if ($exclude -match '^[a-zA-Z]:\\') {

        $exclude = $exclude.TrimEnd('\')

        $files = $files | Where-Object {
            $_.FullName -notlike "$exclude\*"
        }
    }

    # Folder name exclusion
    else {

        $files = $files | Where-Object {

            # Split full path into directory names
            $pathParts = $_.Directory.FullName.Split('\')

            # Keep file only if no folder matches
            -not ($pathParts -contains $exclude)
        }
    }
}

# Exclude file extensions if specified
foreach ($extension in $ExcludeExtension) {

    # Remove leading dot if user typed .txt
    $extension = $extension.TrimStart('.')

    $files = $files | Where-Object {
        $_.Extension -ne ".$extension"
    }
}

    $result = [PSCustomObject]@{
        Path            = (Resolve-Path $Path).Path
        FileCount       = $files.Count
        ExcludedFolders = ($ExcludeFolder -join ", ")
        ExcludedExtensions = ($ExcludeExtension -join ", ")
        IncludeHidden   = [bool]$IncludeHidden
        ScanDate        = Get-Date
    }

    $result

    if ($ExportCsv) {
        $csvFolder = Split-Path $ExportCsv -Parent

        if ($csvFolder -and -not (Test-Path $csvFolder)) {
            New-Item -Path $csvFolder -ItemType Directory -Force | Out-Null
        }

        $result | Export-Csv -Path $ExportCsv -NoTypeInformation
        Write-Host "Report exported to: $ExportCsv"
    }
}
catch {
    Write-Error "Script failed: $($_.Exception.Message)"
}
