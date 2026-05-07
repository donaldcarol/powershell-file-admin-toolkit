[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [string]$Find,

    [Parameter(Mandatory = $true)]
    [string]$ReplaceWith,

    [switch]$Recurse
)

$items = Get-ChildItem -Path $Path -File -Recurse:$Recurse

foreach ($item in $items) {
    $newName = $item.Name -replace $Find, $ReplaceWith

    if ($newName -ne $item.Name) {
        if ($PSCmdlet.ShouldProcess($item.FullName, "Rename to $newName")) {
            Rename-Item -Path $item.FullName -NewName $newName
        }
    }
}