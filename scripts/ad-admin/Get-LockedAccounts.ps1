[CmdletBinding()]
param(
    [string]$ExportCsv = ".\reports\locked-ad-accounts.csv"
)

Import-Module ActiveDirectory

$results = Search-ADAccount -LockedOut |
Select-Object Name, SamAccountName, DistinguishedName

$results | Export-Csv $ExportCsv -NoTypeInformation
$results
