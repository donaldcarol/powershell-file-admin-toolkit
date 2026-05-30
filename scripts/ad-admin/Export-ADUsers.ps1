[CmdletBinding()]
param(
    [string]$SearchBase,
    [string]$ExportCsv = ".\reports\ad-users-report.csv"
)

Import-Module ActiveDirectory

$params = @{
    Filter = "*"
    Properties = @(
        "Department",
        "Title",
        "Mail",
        "Enabled",
        "LastLogonDate",
        "PasswordLastSet"
    )
}

if ($SearchBase) {
    $params.SearchBase = $SearchBase
}

$results = Get-ADUser @params |
Select-Object Name, SamAccountName, Enabled, Mail, Department, Title, LastLogonDate, PasswordLastSet |
Sort-Object Name

$results | Export-Csv $ExportCsv -NoTypeInformation
$results
