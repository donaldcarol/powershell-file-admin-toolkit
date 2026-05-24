$reboot=

Test-Path `
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"

[PSCustomObject]@{

ComputerName=$env:COMPUTERNAME

PendingReboot=$reboot

}
