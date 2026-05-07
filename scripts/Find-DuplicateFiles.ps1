<#
.SYNOPSIS
Find duplicate files based on Name, Size, or Hash.

.DESCRIPTION
This script scans a given folder recursively and identifies duplicate files.
It supports grouping by file name, file size, or file hash (most accurate).

The script also:
- Logs execution using Start-Transcript
- Displays progress when calculating hashes
- Exports results to CSV

.PARAMETER Path
Target folder to scan.

.PARAMETER Mode
Defines how duplicates are detected:
- Name  = same file name
- Size  = same file size
- Hash  = identical file content (recommended)

.PARAMETER ExportCsv
Path where the CSV report will be saved.

.PARAMETER LogPath
Path for the log file.

.EXAMPLE
.\Find-DuplicateFiles.ps1 -Path "G:\lab" -Mode Hash

#>

[CmdletBinding()]
param(
    # Validate that the provided path exists and is a directory
    [Parameter(Mandatory = $true)]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) { $true }
        else { throw "Path does not exist or is not a folder: $_" }
    })]
    [string]$Path,

    # Mode selection with predefined valid values
    [ValidateSet("Name", "Size", "Hash")]
    [string]$Mode = "Hash",

    # CSV export location
    [string]$ExportCsv = ".\duplicates-report.csv",

    # Log file location
    [string]$LogPath = ".\logs\Find-DuplicateFiles.log"
)

# Stop script execution on errors
$ErrorActionPreference = "Stop"

try {
    # Ensure log folder exists
    $logFolder = Split-Path $LogPath -Parent
    if ($logFolder -and -not (Test-Path $logFolder)) {
        New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
    }

    # Start logging session
    Start-Transcript -Path $LogPath -Append

    Write-Host "Scanning path: $Path"
    Write-Host "Mode: $Mode"

    # Retrieve all files recursively
    $files = Get-ChildItem -Path $Path -File -Recurse

    # If no files found, exit early
    if (-not $files) {
        Write-Warning "No files found."
        return
    }

    # Group files depending on selected mode
    switch ($Mode) {

        # Group by file name
        "Name" {
            $groups = $files | Group-Object Name
        }

        # Group by file size
        "Size" {
            $groups = $files | Group-Object Length
        }

        # Group by file hash (most accurate)
        "Hash" {

            $index = 0

            # Calculate hash for each file with progress bar
            $hashList = foreach ($file in $files) {

                $index++

                Write-Progress `
                    -Activity "Calculating file hashes" `
                    -Status $file.FullName `
                    -PercentComplete (($index / $files.Count) * 100)

                # Compute file hash
                Get-FileHash -Path $file.FullName
            }

            # Clear progress bar
            Write-Progress -Activity "Calculating file hashes" -Completed

            # Group by hash value
            $groups = $hashList | Group-Object Hash
        }
    }

    # Filter only duplicate groups (Count > 1)
    $duplicates = $groups | Where-Object { $_.Count -gt 1 }

    # Build output objects
    $result = foreach ($group in $duplicates) {

        foreach ($item in $group.Group) {

            # Special handling for Hash mode (Get-FileHash output)
            if ($Mode -eq "Hash") {

                # Retrieve actual file object
                $fileItem = Get-Item $item.Path

                [PSCustomObject]@{
                    GroupKey      = $group.Name      # grouping key (Name / Size / Hash)
                    FullName      = $fileItem.FullName
                    LengthMB      = [math]::Round($fileItem.Length / 1MB, 2)
                    LastWriteTime = $fileItem.LastWriteTime
                    Mode          = $Mode
                }
            }
            else {
                # For Name/Size grouping, items are already file objects
                [PSCustomObject]@{
                    GroupKey      = $group.Name
                    FullName      = $item.FullName
                    LengthMB      = [math]::Round($item.Length / 1MB, 2)
                    LastWriteTime = $item.LastWriteTime
                    Mode          = $Mode
                }
            }
        }
    }

    # Export results if duplicates exist
    if ($result) {

        # Ensure CSV folder exists
        $csvFolder = Split-Path $ExportCsv -Parent
        if ($csvFolder -and -not (Test-Path $csvFolder)) {
            New-Item -Path $csvFolder -ItemType Directory -Force | Out-Null
        }

        # Export to CSV
        $result |
            Sort-Object GroupKey, FullName |
            Export-Csv -Path $ExportCsv -NoTypeInformation

        Write-Host "Duplicate files found: $($result.Count)"
        Write-Host "Report exported to: $ExportCsv"
    }
    else {
        Write-Host "No duplicate files found."
    }
}
catch {
    # Handle errors
    Write-Error "Script failed: $($_.Exception.Message)"
}
finally {
    # Stop logging session
    Stop-Transcript | Out-Null
}