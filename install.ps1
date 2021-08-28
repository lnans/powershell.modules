Set-ExecutionPolicy Bypass -Scope Process

Write-Host "o Checking Chocolatey install..."

$chocoApp = $(Get-Command "choco")
if ($? -eq $False) {
    "o Installing Chocolatey ..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $chocoApp = $(Get-Command "choco")
}
Write-Host "o Chocolatey version $($chocoApp.Version) installed"

Write-Host "o Installing oh-my-posh..."
choco install oh-my-posh -y

Write-Host "o Installing poshgit..."
choco install poshgit -y

Write-Host "o Installing Windows Terminal..."
choco install microsoft-windows-terminal -y

$modules = $(Get-ChildItem -Path "$PSScriptRoot/src" -Recurse -Include *.psd1)

$modulesEnv = "$HOME/Documents/PowerShell/Modules"
if (!(Test-Path $modulesEnv)) {
    New-Item $modulesEnv -ItemType Directory -Force | Out-Null
}

foreach ($module in $modules) {
    $nameWithoutExt = $module.Name -replace $module.Extension, ""
    Write-Host "# Installing $nameWithoutExt..."
    Import-LocalizedData -BaseDirectory $module.DirectoryName -FileName $module.Name -BindingVariable conf
    
    $moduleDir = "$modulesEnv/$($nameWithoutExt)/$($conf.ModuleVersion)/"
    if (!(Test-Path -Path $moduleDir)) {
        New-Item $moduleDir -Force -ItemType Directory | Out-Null
    }

    Copy-Item "$($module.DirectoryName)/*" $moduleDir -Force -Recurse
}

Write-Host "`n o Done"