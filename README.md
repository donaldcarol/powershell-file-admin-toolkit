![PowerShell](https://img.shields.io/badge/PowerShell-7-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
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

### Remote Administration

- 🌐 Get top CPU-consuming processes
- ⚙️ Check service status
- 🔁 Restart remote services
- 💾 Check disk space usage
- ⏱️ Get server uptime
- 📄 Export results to CSV

---

## 📂 Project Structure

```text
powershell-file-admin-toolkit/
│
├── README.md
├── servers/
│   └── servers.txt
│
├── reports/
├── logs/
│
├── scripts/
│   │
│   ├── file-admin/
│   │   ├── Find-DuplicateFiles.ps1
|   |   ├── Find-FilesByCriteria.ps1
|   |   ├── Find-TextInFiles.ps1
│   │   ├── Rename-FilesByPattern.ps1
│   │   ├── Change-FileExtension.ps1
│   │   ├── Move-FilesByRule.ps1
│   │   └── Count-FilesExcludingFolders.ps1
│   │
│   └── remote-admin/
│       ├── Get-RemoteTopCPU.ps1
│       ├── Get-RemoteServiceStatus.ps1
|       ├── Get-RemoteProcessStatus.ps1
│       ├── Restart-RemoteService.ps1
│       ├── Get-RemoteDiskSpace.ps1
│       └── Get-RemoteUptime.ps1
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
