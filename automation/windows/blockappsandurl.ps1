# Ensuring the script runs with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    exit 1  # Exit if not running as admin (Hexnode should run it with admin privileges)
}

# Inscope blocked external Apps
$apps = @("WhatsApp", "Telegram", "Telegram Desktop")

# 1. Killing Running Instances of inscope external apps
foreach ($app in $apps) {
    Get-Process -Name $app -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

# 2. Remove Installed inscope External Apps
$blockPaths = @(
    "$env:ProgramFiles\WhatsApp",
    "$env:LOCALAPPDATA\WhatsApp",
    "$env:ProgramFiles\Telegram Desktop",
    "$env:LOCALAPPDATA\Telegram Desktop"
)

foreach ($path in $blockPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 3. Blocking inscope external Apps via Windows Firewall
$firewallRules = @(
    @{ Name = "Block WhatsApp Web"; RemoteAddress = "157.240.0.0/16" },
    @{ Name = "Block Telegram Web"; RemoteAddress = "149.154.160.0/20" }
)

foreach ($rule in $firewallRules) {
    if (!(Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName $rule.Name -Direction Outbound -Action Block -RemoteAddress $rule.RemoteAddress -Protocol Any -ErrorAction SilentlyContinue
    }
}

# 4. Blocking inscope external Apps via via Hosts File
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$entries = @"
127.0.0.1 web.whatsapp.com
127.0.0.1 whatsapp.com
127.0.0.1 telegram.org
127.0.0.1 web.telegram.org
"@

foreach ($entry in $entries -split "`n") {
    if (!(Select-String -Path $hostsPath -Pattern $entry -Quiet -ErrorAction SilentlyContinue)) {
        Add-Content -Path $hostsPath -Value "`n$entry" -ErrorAction SilentlyContinue
    }
}

# 5. Blocking inscope external Apps via Group Policy (GPO)
$gpoPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths"
$blockApps = @(
    "%PROGRAMFILES%\WhatsApp\WhatsApp.exe",
    "%LOCALAPPDATA%\WhatsApp\WhatsApp.exe",
    "%PROGRAMFILES%\Telegram Desktop\Telegram.exe",
    "%LOCALAPPDATA%\Telegram Desktop\Telegram.exe"
)

foreach ($app in $blockApps) {
    $hash = [System.Guid]::NewGuid().ToString("N")
    $regPath = "$gpoPath\$hash"
    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "ItemData" -Value $app -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "SaferFlags" -Value 0 -PropertyType DWORD -Force | Out-Null
    }
}

# 6. Blocking inscope external Apps via Microsoft Store
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v RemoveWindowsStore /t REG_DWORD /d 1 /f > $null 2>&1

# 7. Restarting Firewall & Group Policy Services
Restart-Service MpsSvc -Force -ErrorAction SilentlyContinue  # Windows Firewall Service
gpupdate /force > $null 2>&1  # Force Group Policy Update

exit 0  # Ensuring the script exits cleanly
