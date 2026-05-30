[CmdletBinding()]
param(
    [int]$DaysInactive = 90,
    [string]$ExportCsv = ".\reports\inactive-ad-users.csv"
)

Import-Module ActiveDirectory

$cutoff = (Get-Date).AddDays(-$DaysInactive)

$results = Get-ADUser -Filter {
    Enabled -eq $true -and LastLogonDate -lt $cutoff
} -Properties LastLogonDate, Department, Title |
Select-Object Name, SamAccountName, Enabled, LastLogonDate, Department, Title |
Sort-Object LastLogonDate

$results | Export-Csv $ExportCsv -NoTypeInformation
$results
