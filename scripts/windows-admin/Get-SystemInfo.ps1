$os=Get-CimInstance Win32_OperatingSystem

$cpu=Get-CimInstance Win32_Processor

$memory=[math]::Round(
$os.TotalVisibleMemorySize/1MB
,2)

[PSCustomObject]@{

ComputerName=$env:COMPUTERNAME

OS=$os.Caption

CPU=$cpu.Name

RAM_GB=$memory

LastBoot=$os.LastBootUpTime

}
