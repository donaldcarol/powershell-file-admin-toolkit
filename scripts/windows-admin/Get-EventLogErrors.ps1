[CmdletBinding()]
param(

[int]$Hours=24

)

$cutoff=(Get-Date).AddHours(-$Hours)

Get-WinEvent `
-FilterHashtable @{

LogName=@(
"System",
"Application"
)

Level=2

StartTime=$cutoff

} |

Select-Object `
TimeCreated,
LogName,
Id,
ProviderName,
Message
