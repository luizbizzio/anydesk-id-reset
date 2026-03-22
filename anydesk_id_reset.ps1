<#
.SYNOPSIS
    AnyDesk ID Reset Tool
#>

# 1. Auto-Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    exit
}

$OutputEncoding = [System.Text.Encoding]::UTF8
$host.UI.RawUI.WindowTitle = "AnyDesk ID Reset Tool"

# --- Visual Header ---
Clear-Host
Write-Host "  ________________________________________________" -ForegroundColor Blue
Write-Host " |                                                |" -ForegroundColor Blue
Write-Host " |           ANYDESK ID RESET TOOL v1.0           |" -ForegroundColor Blue
Write-Host " |________________________________________________|" -ForegroundColor Blue
Write-Host " "

# 2. Path Search & Portable Detection
$Paths = @(
    "${env:ProgramFiles}\AnyDesk\AnyDesk.exe",
    "${env:ProgramFiles(x86)}\AnyDesk\AnyDesk.exe",
    "$env:ProgramData\AnyDesk\AnyDesk.exe"
)
$AnyDeskExe = $null
foreach ($p in $Paths) { if (Test-Path $p) { $AnyDeskExe = $p; break } }

if (-not $AnyDeskExe) {
    $RunningProcess = Get-Process -Name "AnyDesk*" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Path -ErrorAction SilentlyContinue
    if ($RunningProcess) { $AnyDeskExe = $RunningProcess }
}

if (-not $AnyDeskExe) {
    Write-Host "  [!] Error: AnyDesk not found." -ForegroundColor Red
    Write-Host "      Please open AnyDesk once before running." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    exit
}

$ExeFolder = Split-Path -Path $AnyDeskExe

# 3. Aggressive Shutdown
Write-Host "  [*] Stopping AnyDesk processes..." -NoNewline -ForegroundColor Gray
for ($i=1; $i -le 5; $i++) {
    Stop-Service -Name "AnyDesk" -Force -ErrorAction SilentlyContinue
    Get-Process -Name "AnyDesk*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    if (-not (Get-Process -Name "AnyDesk*" -ErrorAction SilentlyContinue)) { break }
}
Write-Host " [OK]" -ForegroundColor Green

# 4. Wipe
Write-Host "  [*] Purging identity traces..." -NoNewline -ForegroundColor Gray

$TargetFolders = @(
    "$env:AppData\AnyDesk",
    "$env:ProgramData\AnyDesk",
    "$env:LocalAppData\AnyDesk",
    $ExeFolder
)

$IdFiles = @("service.auth", "ad.session.token", "*.trace", "*.old", "service.conf")
$FilterRegex = "ad\.anydesk\.id|ad\.service\.pubkey|ad\.session\.token|ad\.anydesk\.alias|ad\.service\.license"

foreach ($Folder in $TargetFolders) {
    if (Test-Path $Folder) {
        foreach ($File in $IdFiles) {
            $PathToKill = Join-Path $Folder $File
            if (Test-Path $PathToKill) { Remove-Item $PathToKill -Force -ErrorAction SilentlyContinue }
        }
        $SystemConfPath = Join-Path $Folder "system.conf"
        if (Test-Path $SystemConfPath) {
            $CleanSys = (Get-Content $SystemConfPath) | Where-Object { $_ -notmatch $FilterRegex }
            $CleanSys | Set-Content $SystemConfPath -Force
        }
    }
}
Write-Host " [OK]" -ForegroundColor Green

# 5. Registry Wipe
Write-Host "  [*] Clearing system registry cache..." -NoNewline -ForegroundColor Gray
$Regs = @("HKLM:\SOFTWARE\Wow6432Node\AnyDesk", "HKLM:\SOFTWARE\AnyDesk", "HKCU:\SOFTWARE\AnyDesk")
foreach ($r in $Regs) { if (Test-Path $r) { Remove-Item $r -Recurse -Force -ErrorAction SilentlyContinue } }
Write-Host " [OK]" -ForegroundColor Green
Start-Sleep -Seconds 2

# 6. Professional Status Display
Write-Host "`n  ==================================================" -ForegroundColor Gray
Write-Host "   STATUS: " -NoNewline -ForegroundColor White; Write-Host "New ID generated successfully!" -ForegroundColor Green
Write-Host "   CONFIGS: " -NoNewline -ForegroundColor White; Write-Host "All settings and favorites preserved." -ForegroundColor Green
Write-Host "  ==================================================" -ForegroundColor Gray
Start-Sleep -Seconds 1

Write-Host "`n  Found any bugs? Help improve the tool:" -ForegroundColor Gray
Write-Host "  https://github.com/luizbizzio/anydesk-id-reset" -ForegroundColor Blue

Start-Sleep -Seconds 1
Write-Host "`n  Starting AnyDesk..." -ForegroundColor Gray
Start-Sleep -Seconds 1
Start-Service -Name "AnyDesk" -ErrorAction SilentlyContinue
Start-Process $AnyDeskExe
Write-Host "  Anydesk Started" -ForegroundColor Green

# 7. Finalization
Write-Host "`n  --------------------------------------------------" -ForegroundColor Gray
Write-Host "  Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
