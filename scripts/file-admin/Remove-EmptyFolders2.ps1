# Remove-EmptyTempFolders.ps1

$EmptyFolders = Get-ChildItem $env:TEMP -Directory -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
        @(Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0
    }

Write-Host ""
Write-Host "Removing $($EmptyFolders.Count) empty folders..."
Write-Host ""

$EmptyFolders |
    Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host "Done."