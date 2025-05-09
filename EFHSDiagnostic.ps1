Clear-Host
Write-Host "=======================" -ForegroundColor DarkBlue
Write-Host "    EFHSDIAGNOSTICS" -ForegroundColor Cyan
Write-Host "     Version 3.2.1" -ForegroundColor Yellow
Write-Host "    Slater Feistner" -ForegroundColor Red
Write-Host "=======================`n" -ForegroundColor DarkBlue

$host.UI.RawUI.WindowTitle = "EFHSDiagnostics"

# Function to check for updates
function Test-ForUpdates {
    $repoUrl = "https://github.com/PossiblySlater/EFHSDiagnostics"
    $localVersion = "v3.2.1"  # Current version of the script

    Write-Host "Checking for updates..." -ForegroundColor Cyan

    try {
        # Check internet connectivity
        Invoke-WebRequest -Uri "https://api.github.com" -Method Head -TimeoutSec 5 | Out-Null

        # Fetch the latest version from GitHub
        $apiUrl = $repoUrl -replace "https://github.com", "https://api.github.com/repos"
        $releaseInfo = Invoke-RestMethod -Uri "$apiUrl/releases/latest"
        $latestVersion = $releaseInfo.tag_name

        if ($latestVersion -ne $localVersion) {
            Write-Host "A new version ($latestVersion) is available. Current version: $localVersion." -ForegroundColor Yellow
            $update = Read-Host "Do you want to update? (Yes/No)"
            if ($update -eq "Yes") {
                Update-ScriptFiles -RepoUrl $repoUrl
            } else {
                Write-Host "Update canceled." -ForegroundColor Cyan
            }
        } else {
            Write-Host "You are already using the latest version ($localVersion)." -ForegroundColor Green
        }
    } catch {
        Write-Host "Unable to check for updates. Please check your internet connection." -ForegroundColor Red
    }
}

# Function to download and replace files
function Update-ScriptFiles {
    param (
        [string]$RepoUrl
    )
    Write-Host "Downloading and updating files..." -ForegroundColor Cyan
    $zipUrl = "$RepoUrl/archive/refs/heads/main.zip"
    $tempZip = "$env:TEMP\EFHSDiagnostics.zip"
    $localPath = (Get-Location).Path

    try {
        # Download the repository as a ZIP file
        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip

        # Extract the ZIP file and replace the current files
        Expand-Archive -Path $tempZip -DestinationPath $env:TEMP\EFHSDiagnostics -Force
        Copy-Item -Path "$env:TEMP\EFHSDiagnostics\EFHSDiagnostics-main\*" -Destination $localPath -Recurse -Force

        # Clean up temporary files
        Remove-Item $tempZip -Force
        Remove-Item "$env:TEMP\EFHSDiagnostics" -Recurse -Force

        Write-Host "Update completed successfully! Please restart the script." -ForegroundColor Green
        Pause
        Exit
    } catch {
        Write-Host "An error occurred during the update process: $_" -ForegroundColor Red
    }
}

# Check for updates before running diagnostics
Test-ForUpdates

# Ask the user for output format
$outputFormat = Read-Host "Choose output format (Table/List)"

# Function to draw a table row
function Write-TableRow {
    param (
        [string[]]$Columns,
        [int[]]$Widths,
        [ConsoleColor]$Color
    )
    $row = "|"
    for ($i = 0; $i -lt $Columns.Count; $i++) {
        $row += " $($Columns[$i].PadRight($Widths[$i])) |"
    }
    Write-Host $row -ForegroundColor $Color
}

# Function to draw a table separator
function Write-TableSeparator {
    param (
        [int[]]$Widths,
        [ConsoleColor]$Color
    )
    $separator = "+"
    foreach ($width in $Widths) {
        $separator += ("-" * ($width + 2)) + "+"
    }
    Write-Host $separator -ForegroundColor $Color
}

# Function to display operating system info
function Get-OSInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host "=== Operating System ===" -ForegroundColor Green
    if ($outputFormat -eq "Table") {
        Write-TableSeparator -Widths @(40, 60) -Color Green
        Write-TableRow -Columns @("Property", "Value") -Widths @(40, 60) -Color Green
        Write-TableSeparator -Widths @(40, 60) -Color Green
        Write-TableRow -Columns @("OS", $os.Caption) -Widths @(40, 60) -Color Green
        Write-TableRow -Columns @("Version", $os.Version) -Widths @(40, 60) -Color Green
        Write-TableSeparator -Widths @(40, 60) -Color Green
    } else {
        Write-Host "OS         : $($os.Caption)" -ForegroundColor Green
        Write-Host "Version    : $($os.Version)" -ForegroundColor Green
    }
    Write-Host ""
}

# Function to display sound device info
function Get-SoundInfo {
    $soundDevices = Get-CimInstance Win32_SoundDevice
    Write-Host "=== Sound Card(s) ===" -ForegroundColor Cyan
    if ($soundDevices.Count -eq 0) {
        Write-Host "Status: " -ForegroundColor Cyan -NoNewline
        Write-Host "Bad" -ForegroundColor Red
        Write-Host "No sound devices found." -ForegroundColor Yellow
    } else {
        if ($outputFormat -eq "Table") {
            Write-TableSeparator -Widths @(50, 20, 40) -Color Cyan
            Write-TableRow -Columns @("Device Name", "Status", "Manufacturer") -Widths @(50, 20, 40) -Color Cyan
            Write-TableSeparator -Widths @(50, 20, 40) -Color Cyan
            foreach ($device in $soundDevices) {
                $status = if ($device.Status -eq "OK") { "OK" } else { "Bad" }
                Write-TableRow -Columns @($device.Name, $status, $device.Manufacturer) -Widths @(50, 20, 40) -Color Cyan
            }
            Write-TableSeparator -Widths @(50, 20, 40) -Color Cyan
        } else {
            Write-Host "Number of Sound Devices: $($soundDevices.Count)" -ForegroundColor Cyan
            foreach ($device in $soundDevices) {
                Write-Host "Device Name : $($device.Name)" -ForegroundColor Cyan
                Write-Host "Status      : " -ForegroundColor Cyan -NoNewline
                if ($device.Status -eq "OK") {
                    Write-Host "OK" -ForegroundColor Green
                } else {
                    Write-Host "Bad" -ForegroundColor Red
                }
                Write-Host "Manufacturer: $($device.Manufacturer)" -ForegroundColor Cyan
                Write-Host "----------------------------------------" -ForegroundColor Cyan
            }
        }
    }
    Write-Host ""
    Write-Host "Playing Sound Test" -ForegroundColor Cyan
    [console]::beep(500,1000)
    [console]::beep(1000,1000)
    Write-Host "Sound Test Played" -ForegroundColor Cyan
    Write-Host ""
}

# Function to display CPU info
function Get-CPUInfo {
    $cpu = Get-CimInstance Win32_Processor
    Write-Host "=== CPU ===" -ForegroundColor Blue
    if ($outputFormat -eq "Table") {
        Write-TableSeparator -Widths @(40, 60) -Color Blue
        Write-TableRow -Columns @("Property", "Value") -Widths @(40, 60) -Color Blue
        Write-TableSeparator -Widths @(40, 60) -Color Blue
        $status = if ($cpu.LoadPercentage -lt 80) { "OK" } else { "Bad" }
        Write-TableRow -Columns @("Status", $status) -Widths @(40, 60) -Color Blue
        Write-TableRow -Columns @("Name", $cpu.Name) -Widths @(40, 60) -Color Blue
        Write-TableRow -Columns @("Cores", $cpu.NumberOfCores) -Widths @(40, 60) -Color Blue
        Write-TableRow -Columns @("Frequency", ("{0:N2} GHz" -f ($cpu.MaxClockSpeed / 1000))) -Widths @(40, 60) -Color Blue
        Write-TableRow -Columns @("Logical Cores", $cpu.NumberOfLogicalProcessors) -Widths @(40, 60) -Color Blue
        Write-TableSeparator -Widths @(40, 60) -Color Blue
    } else {
        Write-Host "Status      : " -ForegroundColor Blue -NoNewline
        if ($cpu.LoadPercentage -lt 80) {
            Write-Host "OK" -ForegroundColor Green
        } else {
            Write-Host "Bad" -ForegroundColor Red
        }
        Write-Host "Name        : $($cpu.Name)" -ForegroundColor Blue
        Write-Host "Cores       : $($cpu.NumberOfCores)" -ForegroundColor Blue
        Write-Host ("Frequency   : {0:N2} GHz" -f ($cpu.MaxClockSpeed / 1000)) -ForegroundColor Blue
        Write-Host "Logical Cores: $($cpu.NumberOfLogicalProcessors)" -ForegroundColor Blue
        Write-Host "----------------------------------------" -ForegroundColor Blue
    }
    Write-Host ""
}

# Function to display RAM info
function Get-RAMInfo {
    $ramModules = Get-CimInstance Win32_PhysicalMemory
    $ramBytes = ($ramModules | Measure-Object -Property Capacity -Sum).Sum
    $ramGB = [math]::Round($ramBytes / 1GB, 2)
    Write-Host "=== RAM ===" -ForegroundColor DarkMagenta
    if ($outputFormat -eq "Table") {
        Write-TableSeparator -Widths @(30, 30, 30, 30, 30) -Color DarkMagenta
        Write-TableRow -Columns @("Status", "Speed", "Memory Type", "Capacity", "Manufacturer") -Widths @(30, 30, 30, 30, 30) -Color DarkMagenta
        Write-TableSeparator -Widths @(30, 30, 30, 30, 30) -Color DarkMagenta
        foreach ($module in $ramModules) {
            $status = "OK"
            $speed = $module.Speed
            $memoryType = switch ($module.SMBIOSMemoryType) {
                20 { "DDR" }
                21 { "DDR2" }
                24 { "DDR3" }
                26 { "DDR4" }
                28 { "DDR5" }
                default { "Unknown" }
            }
            $capacity = [math]::Round($module.Capacity / 1GB, 2)
            Write-TableRow -Columns @($status, "$speed MHz", $memoryType, "$capacity GB", $module.Manufacturer) -Widths @(30, 30, 30, 30, 30) -Color DarkMagenta
        }
        Write-TableSeparator -Widths @(30, 30, 30, 30, 30) -Color DarkMagenta
    } else {
        Write-Host "Installed RAM: $ramGB GB" -ForegroundColor DarkMagenta
        foreach ($module in $ramModules) {
            $status = "OK"
            $memoryType = switch ($module.SMBIOSMemoryType) {
                20 { "DDR" }
                21 { "DDR2" }
                24 { "DDR3" }
                26 { "DDR4" }
                28 { "DDR5" }
                default { "Unknown" }
            }
            Write-Host "Status       : " -ForegroundColor DarkMagenta -NoNewline
            Write-Host $status -ForegroundColor Green
            Write-Host "Speed        : $($module.Speed) MHz" -ForegroundColor DarkMagenta
            Write-Host "Memory Type  : $memoryType" -ForegroundColor DarkMagenta
            Write-Host "Capacity     : $([math]::Round($module.Capacity / 1GB, 2)) GB" -ForegroundColor DarkMagenta
            Write-Host "Manufacturer : $($module.Manufacturer)" -ForegroundColor DarkMagenta
            Write-Host "----------------------------------------" -ForegroundColor DarkMagenta
        }
    }
    Write-Host ""
}

# Function to display storage info
function Get-StorageInfo {
    $drives = Get-CimInstance Win32_DiskDrive | Where-Object { $_.MediaType -notlike "*Removable*" }
    $totalStorage = 0
    Write-Host "=== Storage ===" -ForegroundColor Yellow
    if ($outputFormat -eq "Table") {
        Write-TableSeparator -Widths @(50, 30, 30, 30, 20) -Color Yellow
        Write-TableRow -Columns @("Drive Name", "Size (GB)", "Drive Letter", "Drive Type", "Status") -Widths @(50, 30, 30, 30, 20) -Color Yellow
        Write-TableSeparator -Widths @(50, 30, 30, 30, 20) -Color Yellow
        foreach ($drive in $drives) {
            $sizeGB = [math]::Round($drive.Size / 1GB, 2)
            $totalStorage += $sizeGB
            $status = if ($drive.Status -eq "OK") { "OK" } else { "Bad" }
            Write-TableRow -Columns @($drive.Model, $sizeGB, $drive.DeviceID, $drive.MediaType, $status) -Widths @(50, 30, 30, 30, 20) -Color Yellow
        }
        Write-TableSeparator -Widths @(50, 30, 30, 30, 20) -Color Yellow
        Write-Host ("Total Storage : {0:N2} GB" -f $totalStorage) -ForegroundColor Yellow
    } else {
        foreach ($drive in $drives) {
            $sizeGB = [math]::Round($drive.Size / 1GB, 2)
            $totalStorage += $sizeGB
            Write-Host "Drive Name   : $($drive.Model)" -ForegroundColor Yellow
            Write-Host "Size         : $sizeGB GB" -ForegroundColor Yellow
            Write-Host "Drive Letter : $($drive.DeviceID)" -ForegroundColor Yellow
            Write-Host "Drive Type   : $($drive.MediaType)" -ForegroundColor Yellow
            Write-Host "Status       : " -ForegroundColor Yellow -NoNewline
            if ($drive.Status -eq "OK") {
                Write-Host "OK" -ForegroundColor Green
            } else {
                Write-Host "Bad" -ForegroundColor Red
            }
            Write-Host "----------------------------------------" -ForegroundColor Yellow
        }
        Write-Host ("Total Storage : {0:N2} GB" -f $totalStorage) -ForegroundColor Yellow
    }
    Write-Host ""
}

# Function to display GPU info
function Get-GPUInfo {
    $gpus = Get-CimInstance Win32_VideoController
    Write-Host "=== Graphics Card(s) ===" -ForegroundColor Magenta
    if ($gpus.Count -eq 0) {
        Write-Host "Status: " -ForegroundColor Magenta -NoNewline
        Write-Host "Bad" -ForegroundColor Red
        Write-Host "No graphics card found." -ForegroundColor Yellow
    } else {
        if ($outputFormat -eq "Table") {
            Write-TableSeparator -Widths @(50, 20, 30) -Color Magenta
            Write-TableRow -Columns @("GPU", "Status", "VRAM (MB)") -Widths @(50, 20, 30) -Color Magenta
            Write-TableSeparator -Widths @(50, 20, 30) -Color Magenta
            foreach ($gpu in $gpus) {
                $status = if ($gpu.Status -eq "OK") { "OK" } else { "Bad" }
                $vramMB = if ($null -ne $gpu.AdapterRAM) { [math]::Round($gpu.AdapterRAM / 1MB, 2) } else { "Unknown" }
                Write-TableRow -Columns @($gpu.Name, $status, $vramMB) -Widths @(50, 20, 30) -Color Magenta
            }
            Write-TableSeparator -Widths @(50, 20, 30) -Color Magenta
        } else {
            foreach ($gpu in $gpus) {
                Write-Host "GPU         : $($gpu.Name)" -ForegroundColor Magenta
                Write-Host "Status      : " -ForegroundColor Magenta -NoNewline
                if ($gpu.Status -eq "OK") {
                    Write-Host "OK" -ForegroundColor Green
                } else {
                    Write-Host "Bad" -ForegroundColor Red
                }
                if ($null -ne $gpu.AdapterRAM) {
                    Write-Host "VRAM        : $([math]::Round($gpu.AdapterRAM / 1MB, 2)) MB" -ForegroundColor Magenta
                } else {
                    Write-Host "VRAM        : Unknown" -ForegroundColor Magenta
                }
                Write-Host "----------------------------------------" -ForegroundColor Magenta
            }
        }
    }
    Write-Host ""
}

# Call all functions
Get-OSInfo
Get-SoundInfo
Get-CPUInfo
Get-RAMInfo
Get-StorageInfo
Get-GPUInfo

Pause