Clear-Host
Write-Host "=======================" -ForegroundColor White
Write-Host "   EFHS  DIAGNOSTICS" -ForegroundColor Cyan
Write-Host "      Version 1.7" -ForegroundColor Yellow
Write-Host "    Slater Feistner" -ForegroundColor Red
Write-Host "=======================`n" -ForegroundColor White

# --- CPU Info ---
$cpu = Get-CimInstance Win32_Processor
Write-Host "--- CPU ---" -ForegroundColor Blue
if ($cpu.LoadPercentage -lt 80) {
    Write-Host "Status: OK" -ForegroundColor Green
} else {
    Write-Host "Status: Bad" -ForegroundColor Red
}
Write-Host "Name       : $($cpu.Name)" -ForegroundColor DarkBlue
Write-Host "Cores      : $($cpu.NumberOfCores)" -ForegroundColor DarkBlue
Write-Host ("Frequency  : {0:N2} GHz" -f ($cpu.MaxClockSpeed / 1000)) -ForegroundColor DarkBlue
Write-Host "Logical Cores: $($cpu.NumberOfLogicalProcessors)" -ForegroundColor DarkBlue
Write-Host ""

# --- Operating System ---
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "--- Operating System ---" -ForegroundColor Green
Write-Host "OS         : $($os.Caption)" -ForegroundColor Green
Write-Host "Version    : $($os.Version)" -ForegroundColor Green
Write-Host ""

# --- RAM Info ---
$ramModules = Get-CimInstance Win32_PhysicalMemory
if ($ramModules -and $ramModules.Count -gt 0) {
    $allGood = $true
    foreach ($module in $ramModules) {
        if ($module.Status -ne "OK") {
            $allGood = $false
            break
        }
    }
    if ($allGood) {
        Write-Host "Status: OK" -ForegroundColor Green
    } else {
        Write-Host "Status: Bad" -ForegroundColor Red
    }
} else {
    Write-Host "Status: No RAM modules detected" -ForegroundColor Yellow
}
$ramBytes = ($ramModules | Measure-Object -Property Capacity -Sum).Sum
$ramGB = [math]::Round($ramBytes / 1GB, 2)
Write-Host "--- RAM ---" -ForegroundColor Red
Write-Host "Installed RAM : $ramGB GB" -ForegroundColor Red

foreach ($module in $ramModules) {
    $speed = $module.Speed
    $memoryType = switch ($module.SMBIOSMemoryType) {
        20 { "DDR" }
        21 { "DDR2" }
        22 { "DDR2 FB-DIMM" }
        24 { "DDR3" }
        26 { "DDR4" }
        27 { "LPDDR4" }
        28 { "DDR5" }
        29 { "LPDDR5" }
        default { "Unknown" }
    }
    Write-Host "Speed        : $speed MHz" -ForegroundColor Red
    Write-Host "Memory Type  : $memoryType" -ForegroundColor Red
}
Write-Host ""

# --- Storage Info ---
$drives = Get-CimInstance Win32_DiskDrive | Where-Object { $_.MediaType -notlike "*Removable*" }
$totalStorage = 0
Write-Host "--- Storage ---" -ForegroundColor Yellow
$allDrivesGood = $true
foreach ($drive in $drives) {
    if ($drive.Status -ne "OK") {
        $allDrivesGood = $false
        break
    }
}
if ($allDrivesGood) {
    Write-Host "Status: OK" -ForegroundColor Green
} else {
    Write-Host "Status: Bad" -ForegroundColor Red
}
foreach ($drive in $drives) {
    $sizeGB = $drive.Size / 1GB
    $totalStorage += $sizeGB
    Write-Host ("Drive Name   : {0}" -f $drive.Model) -ForegroundColor Yellow
    Write-Host ("Size         : {0:N2} GB" -f $sizeGB) -ForegroundColor Yellow
}
Write-Host ("Total Storage : {0:N2} GB" -f $totalStorage) -ForegroundColor Yellow
Write-Host ""

# --- GPU Info ---
$gpus = Get-CimInstance Win32_VideoController
Write-Host "--- Graphics Card(s) ---" -ForegroundColor Magenta
if ($gpus.Count -eq 0) {
    Write-Host "Status: Bad" -ForegroundColor Red
    Write-Host "No graphics card found." -ForegroundColor Red
} else {
    $allGPUsGood = $true
    foreach ($gpu in $gpus) {
        if ($gpu.Status -ne "OK") {
            $allGPUsGood = $false
            break
        }
    }
    if ($allGPUsGood) {
        Write-Host "Status: OK" -ForegroundColor Green
    } else {
        Write-Host "Status: Bad" -ForegroundColor Red
    }
    Write-Host "Number of GPUs: $($gpus.Count)" -ForegroundColor Magenta
}
foreach ($gpu in $gpus) {
    Write-Host "GPU         : $($gpu.Name)" -ForegroundColor Magenta
    if ($null -ne $gpu.AdapterRAM) {
        $vramMB = [math]::Round($gpu.AdapterRAM / 1MB, 2)
        Write-Host "VRAM        : $vramMB MB" -ForegroundColor Magenta
    } else {
        Write-Host "VRAM        : Unknown" -ForegroundColor Magenta
    }
}
Write-Host ""
Pause
