[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [int]$DaysInactive = 180,
    [string]$ExportCsv = ".\reports\users-to-disable.csv"
)

Import-Module ActiveDirectory

$cutoff = (Get-Date).AddDays(-$DaysInactive)

$users = Get-ADUser -Filter {
    Enabled -eq $true -and LastLogonDate -lt $cutoff
} -Properties LastLogonDate |
Select-Object Name, SamAccountName, DistinguishedName, LastLogonDate

$users | Export-Csv $ExportCsv -NoTypeInformation

foreach ($user in $users) {
    if ($PSCmdlet.ShouldProcess($user.SamAccountName, "Disable AD user")) {
        Disable-ADAccount -Identity $user.DistinguishedName
    }
}

$users
