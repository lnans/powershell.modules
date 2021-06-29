Import-Module posh-git
Import-Module oh-my-posh
Import-Module beautiful-ls
Set-PoshPrompt -Theme $HOME\custom.omp.json

function Get-GitCmdStatus { & git status -sb }
function Get-GitCmdLog { & git log --oneline --all --graph --decorate $args }
function Get-GitBranch { & git branch -a }


New-Alias -Name ll -Value Get-ChildItemColorized
New-Alias -Name gs -Value Get-GitCmdStatus
New-Alias -Name gl -Value Get-GitCmdLog -Force -Option AllScope
New-Alias -Name gb -Value Get-GitBranch

Clear-Host