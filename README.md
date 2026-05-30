''![PowerShell](https://img.shields.io/badge/PowerShell-7-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![Platform](https://img.shields.io/badge/Windows-Servers-red)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/status-active-success)

# PowerShell  Admin Toolkit

A collection of practical PowerShell scripts for file management and remote Windows administration.

This project focuses on real-world administrative scenarios such as:

- File cleanup and organization
- Duplicate detection
- Batch rename operations
- Remote server administration
- Service management
- Disk usage reporting
- Process monitoring
- Uptime reporting
- CSV reporting and logging

---

## 🚀 Features

### File Administration

- 🔍 Find duplicate files
- 🔍 Find files by criteria
- 🔍 Find text in files
- ✏️ Rename files using regex patterns
- 🔄 Change file extensions in bulk
- 📂 Move files based on rules
- 📊 Count files with exclusion rules
- 🚫 Exclude folders and extensions
- 📁 Remove Empty folders

### Remote Administration

- 🌐 Get top CPU-consuming processes
- ⚙️ Check service status
- 🔁 Restart remote services
- 💾 Check disk space usage
- ⏱️ Get server uptime
- 📄 Export results to CSV

### Windows Server Administration

- 👤 Get local administrators
- ℹ️ Get System Information
- ⚡ Get Events from Eventlog
- 🧑‍💻 Get installed softwares on server
- 💽 Get encrypted volumes
- ☑️ Get program that run on startup
- 🕐 Get running processes 

### Active Directory Administration

- 👤 Get inactive users
- ℹ️ Get locked accounts
- 👥 Disable inactive users
- 🧾 Export AD users
- 🔑 Get password expiry

---

## 📂 Project Structure

```text
powershell-admin-toolkit/
│
├── README.md
│
├── servers/
│   └── servers.txt
│
├── reports/
├── logs/
│
├── scripts/
│
│   ├── file-admin/
│   │   ├── Find-DuplicateFiles.ps1
│   │   ├── Rename-FilesByPattern.ps1
│   │   ├── Find-FilesByCriteria.ps1
│   │   ├── Find-TextInFiles.ps1
│   │   └── Count-FilesExcludingFolders.ps1
│   │
│   ├── remote-admin/
│   │   ├── Get-RemoteTopCPU.ps1
│   │   ├── Get-RemoteDiskSpace.ps1
│   │   ├── Get-RemoteUptime.ps1
│   │   ├── Get-RemoteServiceStatus.ps1
│   │   └── Restart-RemoteService.ps1
│   │
│   ├── windows-admin/
|   |   ├── Get-InstalledSoftware.ps1
|   |   ├── Get-EventLogErrors.ps1
|   |   ├── Check-BitLockerStatus.ps1
|   |   ├── Get-LocalAdmins.ps1
|   |   ├── Get-SystemInfo.ps1
|   |   ├── Get-LargeFolders.ps1
|   |   ├── Get-PendingReboot.ps1
|   |   ├── Get-TopMemoryProcesses.ps1
|   |   ├── Clear-TempFiles.ps1
|   |   └── Get-StartupPrograms.ps1
│   │
│   └── ad-admin/
│       ├── Get-InactiveUsers.ps1
│       ├── Get-LockedAccounts.ps1
│       ├── Disable-InactiveUsers.ps1
│       ├── Export-ADUsers.ps1
│       └── Get-PasswordExpiry.ps1
```

---

## 🖥️ Examples

### Find duplicate files

```powershell
.\scripts\file-admin\Find-DuplicateFiles.ps1 `
-Path "G:\lab" `
-Mode Hash
```

### Find files by criteria

```
.\Find-FilesByCriteria.ps1 `
-Path "M:\films" `
-Extension "mkv","mp4" `
-MinSizeMB 700 `
-CreatedAfter "2024-01-01" `
-CreatedBefore "2024-12-31"

```

### Search text inside files

```powershell
.\scripts\file-admin\Find-TextInFiles.ps1 `
-Path "C:\Logs" `
-Pattern "error","failed","critical" `
-Extension "log","txt"
```

### Count files while excluding folders and extensions

```powershell
.\scripts\file-admin\Count-FilesExcludingFolders.ps1 `
-Path "C:\Windows" `
-ExcludeFolder "temp","Security" `
-ExcludeExtension "txt","nfo"
```

### Remove empty folders from $env:TEMP

```
.\scripts\file-admin\Remove-EmptyTempFolders.ps1

Recursively scans the current user's TEMP directory and removes orphaned empty folders left behind by installers, update processes and applications such as OneDrive, Docker Desktop, VS Code and Install4j-based software.

Features:
- Safe recursive scan
- Supports -WhatIf
- Ignores access denied errors
- Useful for periodic workstation maintenance
```

### Check disk space remotely

```powershell
.\scripts\remote-admin\Get-RemoteDiskSpace.ps1 `
-ComputerName server1,server2 `
-DriveLetter C
```

### Restart service remotely

```powershell
.\scripts\remote-admin\Restart-RemoteService.ps1 `
-ComputerName server1,server2 `
-ServiceName Spooler `
-WhatIf
```

---

## ⚠️ Safety

Many scripts support:

- `-WhatIf`
- `-Confirm`
- Error handling
- CSV export
- Logging

---

## 🧠 Design Principles

- Advanced PowerShell functions
- Remote administration support
- Safe execution model
- Reusable automation patterns
- Real-world administration scenarios

---

## 👨‍💻 Author

Donald Carol

Cloud / Infrastructure Engineer

---

## 📌 Future Improvements

- Parallel execution (`ForEach-Object -Parallel`)
- Retry logic
- Progress bars
- Logging enhancements
- HTML reports
- Email notifications
