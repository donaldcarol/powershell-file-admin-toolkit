[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [string]$OldExtension,

    [Parameter(Mandatory = $true)]
    [string]$NewExtension,

    [switch]$Recurse
)

$OldExtension = $OldExtension.TrimStart(".")
$NewExtension = $NewExtension.TrimStart(".")

$items = Get-ChildItem -Path $Path -File -Filter "*.$OldExtension" -Recurse:$Recurse

foreach ($item in $items) {
    $newName = [System.IO.Path]::ChangeExtension($item.Name, $NewExtension)

    if ($PSCmdlet.ShouldProcess($item.FullName, "Change extension to .$NewExtension")) {
        Rename-Item -Path $item.FullName -NewName $newName
    }
}