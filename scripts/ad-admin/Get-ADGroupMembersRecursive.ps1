[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$GroupName,

    [string]$ExportCsv = ".\reports\ad-group-members.csv"
)

Import-Module ActiveDirectory

$results = Get-ADGroupMember -Identity $GroupName -Recursive |
Select-Object Name, SamAccountName, ObjectClass, DistinguishedName |
Sort-Object ObjectClass, Name

$results | Export-Csv $ExportCsv -NoTypeInformation
$results
