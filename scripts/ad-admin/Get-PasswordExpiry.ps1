[CmdletBinding()]
param(
    [int]$DaysToExpire = 14,
    [string]$ExportCsv = ".\reports\password-expiry-report.csv"
)

Import-Module ActiveDirectory

$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

$results = Get-ADUser -Filter { Enabled -eq $true -and PasswordNeverExpires -eq $false } `
-Properties PasswordLastSet, PasswordNeverExpires, Mail |
ForEach-Object {
    $expiryDate = $_.PasswordLastSet + $maxPasswordAge
    $daysLeft = ($expiryDate - (Get-Date)).Days

    if ($daysLeft -le $DaysToExpire -and $daysLeft -ge 0) {
        [PSCustomObject]@{
            Name          = $_.Name
            SamAccountName = $_.SamAccountName
            Mail          = $_.Mail
            PasswordLastSet = $_.PasswordLastSet
            ExpiryDate    = $expiryDate
            DaysLeft      = $daysLeft
        }
    }
}

$results | Export-Csv $ExportCsv -NoTypeInformation
$results
