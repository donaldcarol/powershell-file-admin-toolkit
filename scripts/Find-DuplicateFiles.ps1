<#
.SYNOPSIS
Find duplicate files by Name, Size, or Hash.

.EXAMPLE
.\Find-DuplicateFiles.ps1 -Path "G:\lab" -Mode Hash -ExportCsv ".\reports\duplicates.csv"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) { $true }
        else { throw "Path does not exist or is not a folder: $_" }
    })]
    [string]$Path,

    [ValidateSet("Name", "Size", "Hash")]
    [string]$Mode = "Hash",

    [string]$ExportCsv = ".\duplicates-report.csv",

    [string]$LogPath = ".\logs\Find-DuplicateFiles.log"
)

$ErrorActionPreference = "Stop"

try {
    $logFolder = Split-Path $LogPath -Parent
    if ($logFolder -and -not (Test-Path $logFolder)) {
        New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
    }

    Start-Transcript -Path $LogPath -Append

    Write-Host "Scanning path: $Path"
    Write-Host "Mode: $Mode"

    $files = Get-ChildItem -Path $Path -File -Recurse

    if (-not $files) {
        Write-Warning "No files found."
        return
    }

    switch ($Mode) {
        "Name" {
            $groups = $files | Group-Object Name
        }

        "Size" {
            $groups = $files | Group-Object Length
        }

        "Hash" {
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

    $duplicates = $groups | Where-Object { $_.Count -gt 1 }

    $result = foreach ($group in $duplicates) {
        foreach ($item in $group.Group) {
            if ($Mode -eq "Hash") {
                $fileItem = Get-Item $item.Path

                [PSCustomObject]@{
                    GroupKey      = $group.Name
                    FullName      = $fileItem.FullName
                    LengthMB      = [math]::Round($fileItem.Length / 1MB, 2)
                    LastWriteTime = $fileItem.LastWriteTime
                    Mode          = $Mode
                }
            }
            else {
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

    if ($result) {
        $csvFolder = Split-Path $ExportCsv -Parent
        if ($csvFolder -and -not (Test-Path $csvFolder)) {
            New-Item -Path $csvFolder -ItemType Directory -Force | Out-Null
        }

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
    Write-Error "Script failed: $($_.Exception.Message)"
}
finally {
    Stop-Transcript | Out-Null
}