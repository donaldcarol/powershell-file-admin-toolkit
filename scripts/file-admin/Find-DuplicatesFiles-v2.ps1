<#
.SYNOPSIS
Find and optionally remove duplicate files by Name, Size, or Hash.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) { $true }
        else { throw "Path does not exist or is not a folder: $_" }
    })]
    [string]$Path,

    [ValidateSet("Name", "Size", "Hash")]
    [string]$Mode = "Hash",

    [ValidateSet("Newest", "Oldest")]
    [string]$Keep = "Newest",

    [switch]$Delete,

    [string[]]$ExcludeFolder = @(".git", "node_modules"),

    [string]$ExportCsv = ".\reports\duplicates-report.csv",

    [string]$LogPath = ".\logs\Find-DuplicateFiles.log"
)

$ErrorActionPreference = "Stop"

try {
    # Ensure log folder exists
    $logFolder = Split-Path $LogPath -Parent
    if ($logFolder -and -not (Test-Path $logFolder)) {
        New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
    }

    Start-Transcript -Path $LogPath -Append

    Write-Host "Scanning path: $Path"
    Write-Host "Mode: $Mode"
    Write-Host "Keep: $Keep"
    Write-Host "Delete mode: $Delete"

    # Get files and exclude unwanted folders
    $files = Get-ChildItem -Path $Path -File -Recurse |
        Where-Object {
            $filePath = $_.FullName
            -not ($ExcludeFolder | Where-Object { $filePath -like "*\$_\*" })
        }

    if (-not $files) {
        Write-Warning "No files found."
        return
    }

    # Group files based on selected mode
    switch ($Mode) {
        "Name" {
            $groups = $files | Group-Object Name
        }

        "Size" {
            $groups = $files | Group-Object Length
        }

        "Hash" {
            $index = 0

            $hashList = foreach ($file in $files) {
                $index++

                Write-Progress `
                    -Activity "Calculating file hashes" `
                    -Status $file.FullName `
                    -PercentComplete (($index / $files.Count) * 100)

                Get-FileHash -Path $file.FullName
            }

            Write-Progress -Activity "Calculating file hashes" -Completed

            $groups = $hashList | Group-Object Hash
        }
    }

    # Keep only duplicate groups
    $duplicateGroups = $groups | Where-Object { $_.Count -gt 1 }

    # Convert grouped items back to real file objects
    $filesToDelete = foreach ($group in $duplicateGroups) {

        if ($Mode -eq "Hash") {
            $groupFiles = $group.Group | ForEach-Object { Get-Item $_.Path }
        }
        else {
            $groupFiles = $group.Group
        }

        # Decide which file to keep
        if ($Keep -eq "Newest") {
            $orderedFiles = $groupFiles | Sort-Object LastWriteTime -Descending
        }
        else {
            $orderedFiles = $groupFiles | Sort-Object LastWriteTime
        }

        # Skip first file = keep it; return the rest for deletion/reporting
        $orderedFiles | Select-Object -Skip 1
    }

    # Build report
    $report = $filesToDelete | Select-Object `
        FullName,
        @{Name = "LengthMB"; Expression = { [math]::Round($_.Length / 1MB, 2) }},
        LastWriteTime,
        @{Name = "Mode"; Expression = { $Mode }},
        @{Name = "Action"; Expression = { if ($Delete) { "DeleteCandidate" } else { "ReportOnly" } }}

    # Ensure report folder exists
    $csvFolder = Split-Path $ExportCsv -Parent
    if ($csvFolder -and -not (Test-Path $csvFolder)) {
        New-Item -Path $csvFolder -ItemType Directory -Force | Out-Null
    }

    # Export report
    $report | Export-Csv -Path $ExportCsv -NoTypeInformation

    Write-Host "Duplicate files selected: $($filesToDelete.Count)"
    Write-Host "Report exported to: $ExportCsv"

    # Optional delete
    if ($Delete) {
        foreach ($file in $filesToDelete) {
            if ($PSCmdlet.ShouldProcess($file.FullName, "Remove duplicate file")) {
                Remove-Item -Path $file.FullName -Force
            }
        }
    }
    else {
        Write-Host "Report-only mode. No files deleted."
    }
}
catch {
    Write-Error "Script failed: $($_.Exception.Message)"
}
finally {
    Stop-Transcript | Out-Null
}