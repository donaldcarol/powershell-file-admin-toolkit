# Remove-EmptyFolders.ps1

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$Path
)

if (!(Test-Path $Path)) {
    Write-Error "Path not found: $Path"
    exit 1
}

$emptyFolders = Get-ChildItem -Path $Path -Directory -Recurse -Force -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending |
    Where-Object {
        @(Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0
    }

Write-Host "Empty folders found: $($emptyFolders.Count)"

foreach ($folder in $emptyFolders) {
    if ($PSCmdlet.ShouldProcess($folder.FullName, "Remove empty folder")) {
        Remove-Item $folder.FullName -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Done."
