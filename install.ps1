$modules = $(Get-ChildItem -Recurse -Include *.psd1)

$modulesEnv = "$HOME/Documents/PowerShell/Modules"
foreach($module in $modules) {
    $nameWithoutExt = $module.Name -replace $module.Extension, ""
    Write-Host "# Installing $nameWithoutExt"
    Import-LocalizedData -BaseDirectory $module.DirectoryName -FileName $module.Name -BindingVariable conf
    
    if(!(Test-Path -Path "$modulesEnv/$($nameWithoutExt)")) {
        New-Item "$modulesEnv/$($nameWithoutExt)" -Force -ItemType Directory | Out-Null
    }
    if(!(Test-Path -Path "$modulesEnv/$($nameWithoutExt)/$($conf.ModuleVersion)")) {
        New-Item "$modulesEnv/$($nameWithoutExt)/$($conf.ModuleVersion)" -Force -ItemType Directory | Out-Null
    }

    Copy-Item "$($module.DirectoryName)/*" "$HOME/Documents/PowerShell/Modules/$($nameWithoutExt)/$($conf.ModuleVersion)/" -Force -Recurse
}

Write-Host "`n o Done"