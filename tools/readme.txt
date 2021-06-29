### Install Powershell Core
* [On Github](https://github.com/PowerShell/PowerShell/releases)

### Get Windows terminal
* On Microsoft Store
* [On Github](https://github.com/microsoft/terminal/releases)

### Install font

* Install fonts in the `Fonts` directory. (Right click + Install)


### Configuration
In a powershell prompt:
```
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
```

Then copy the content of `profile.ps1` in your profile settings:
```
notepad $PROFILE
```

Finally, configure the Windows Powershell settings.
Exemple is in the `settings.json` file.