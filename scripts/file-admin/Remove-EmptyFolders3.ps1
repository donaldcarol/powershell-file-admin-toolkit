[CmdletBinding(SupportsShouldProcess)]
param()

$EmptyFolders = Get-ChildItem $env:TEMP -Directory -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
        @(Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0
    }

foreach ($Folder in $EmptyFolders)
{
    if ($PSCmdlet.ShouldProcess($Folder.FullName, "Remove empty folder"))
    {
        Remove-Item $Folder.FullName -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Processed $($EmptyFolders.Count) folders."