[CmdletBinding()]
param(

    [string]$ExportCsv=".\\reports\\installed-software.csv"

)

$results=Get-ItemProperty `
HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* ,
HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |

Where-Object {$_.DisplayName} |

Select-Object `
DisplayName,
DisplayVersion,
Publisher,
InstallDate |

Sort-Object DisplayName

$results |
Export-Csv $ExportCsv -NoTypeInformation

$results
