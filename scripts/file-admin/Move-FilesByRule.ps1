[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [string]$Destination,

    [string]$Extension,

    [string]$NameContains,

    [switch]$Recurse
)

if (-not (Test-Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force | Out-Null
}

$items = Get-ChildItem -Path $Path -File -Recurse:$Recurse

if ($Extension) {
    $Extension = $Extension.TrimStart(".")
    $items = $items | Where-Object { $_.Extension -eq ".$Extension" }
}

if ($NameContains) {
    $items = $items | Where-Object { $_.Name -like "*$NameContains*" }
}

foreach ($item in $items) {
    $targetPath = Join-Path $Destination $item.Name

    if ($PSCmdlet.ShouldProcess($item.FullName, "Move to $targetPath")) {
        Move-Item -Path $item.FullName -Destination $targetPath
    }
}