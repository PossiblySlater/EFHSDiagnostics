Clear-Host
Write-Host "=======================" -ForegroundColor DarkBlue
Write-Host "    EFHSDIAGNOSTICS" -ForegroundColor Cyan
Write-Host "      Version 2.2" -ForegroundColor Yellow
Write-Host "    Slater Feistner" -ForegroundColor Red
Write-Host "=======================`n" -ForegroundColor DarkBlue

# --- CPU Info ---
$cpu = Get-CimInstance Win32_Processor
Write-Host "=== CPU ===" -ForegroundColor Blue
if ($cpu.LoadPercentage -lt 80) {
    Write-Host "Status: " -ForegroundColor Blue -NoNewline
    Write-Host  "OK" -ForegroundColor Green 
} else {
    Write-Host "Status: " -ForegroundColor Blue -NoNewline
    Write-Host  "Bad" -ForegroundColor Red 
}
Write-Host "Name       : $($cpu.Name)" -ForegroundColor Blue
Write-Host "Cores      : $($cpu.NumberOfCores)" -ForegroundColor Blue
Write-Host ("Frequency  : {0:N2} GHz" -f ($cpu.MaxClockSpeed / 1000)) -ForegroundColor Blue
Write-Host "Logical Cores: $($cpu.NumberOfLogicalProcessors)" -ForegroundColor Blue
Write-Host ""

# --- Operating System ---
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "=== Operating System ===" -ForegroundColor Green
Write-Host "OS         : $($os.Caption)" -ForegroundColor Green
Write-Host "Version    : $($os.Version)" -ForegroundColor Green
Write-Host ""

# --- RAM Info ---
$ramModules = Get-CimInstance Win32_PhysicalMemory
$ramBytes = ($ramModules | Measure-Object -Property Capacity -Sum).Sum
$ramGB = [math]::Round($ramBytes / 1GB, 2)
Write-Host "=== RAM ===" -ForegroundColor DarkMagenta
Write-Host "Installed RAM : $ramGB GB" -ForegroundColor DarkMagenta
Write-Host "----------------------------------------" -ForegroundColor DarkMagenta
foreach ($module in $ramModules) {
    Write-Host "Status: " -ForegroundColor DarkMagenta -NoNewline
    Write-Host  "OK" -ForegroundColor Green 
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
    Write-Host "Speed        : $speed MHz" -ForegroundColor DarkMagenta
    Write-Host "Memory Type  : $memoryType" -ForegroundColor DarkMagenta
    Write-Host "Capacity     : $($module.Capacity / 1GB) GB" -ForegroundColor DarkMagenta
    Write-Host "Manufacturer : $($module.Manufacturer)" -ForegroundColor DarkMagenta
    Write-Host "----------------------------------------" -ForegroundColor DarkMagenta
}
Write-Host ""

# --- Storage Info ---
$drives = Get-CimInstance Win32_DiskDrive | Where-Object { $_.MediaType -notlike "*Removable*" }
$totalStorage = 0
Write-Host "=== Storage ===" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Yellow
foreach ($drive in $drives) {
    $sizeGB = $drive.Size / 1GB
    $totalStorage += $sizeGB
    Write-Host ("Drive Name   : {0}" -f $drive.Model) -ForegroundColor Yellow
    Write-Host ("Size         : {0:N2} GB" -f $sizeGB) -ForegroundColor Yellow
    Write-Host ("Drive Letter : {0}" -f $drive.DeviceID) -ForegroundColor Yellow
    Write-Host ("Drive Type   : {0}" -f $drive.MediaType) -ForegroundColor Yellow
    Write-Host "Status       : " -ForegroundColor Yellow -NoNewline
    if ($drive.Status -eq "OK") {
        Write-Host "OK" -ForegroundColor Green
    } else {
        Write-Host "Bad" -ForegroundColor Red
    }
    Write-Host "----------------------------------------" -ForegroundColor Yellow
}
Write-Host ("Total Storage : {0:N2} GB" -f $totalStorage) -ForegroundColor Yellow
Write-Host ""

# --- GPU Info ---
$gpus = Get-CimInstance Win32_VideoController
Write-Host "=== Graphics Card(s) ===" -ForegroundColor Magenta
if ($gpus.Count -eq 0) {
    Write-Host "Status: " -ForegroundColor Magenta -NoNewline
    Write-Host  "Bad" -ForegroundColor Red 
    Write-Host "No graphics card found." -ForegroundColor Yellow
} else {
    Write-Host "Number of GPUs: $($gpus.Count)" -ForegroundColor Magenta
    Write-Host "----------------------------------------" -ForegroundColor Magenta
    foreach ($gpu in $gpus) {
        Write-Host "GPU         : $($gpu.Name)" -ForegroundColor Magenta
        Write-Host "Status      : " -ForegroundColor Magenta -NoNewline
        if ($gpu.Status -eq "OK") {
            Write-Host "OK" -ForegroundColor Green
        } else {
            Write-Host "Bad" -ForegroundColor Red
        }
        if ($null -ne $gpu.AdapterRAM) {
            $vramMB = [math]::Round($gpu.AdapterRAM / 1MB, 2)
            Write-Host "VRAM        : $vramMB MB" -ForegroundColor Magenta
        } else {
            Write-Host "VRAM        : Unknown" -ForegroundColor Magenta
        }
        Write-Host "----------------------------------------" -ForegroundColor Magenta
    }
}
Write-Host ""
Pause
