# Remove-EmptyTempFolders.ps1

$EmptyFolders = Get-ChildItem $env:TEMP -Directory -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
        @(Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0
    }

Write-Host ""
Write-Host "Empty folders found: $($EmptyFolders.Count)"
Write-Host ""

$EmptyFolders |
    Select-Object FullName