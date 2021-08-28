using namespace System.Collections.Generic
using namespace System.IO

[console]::CursorVisible = $false
[console]::TreatControlCAsInput = $true

Import-Module -Name "$PSScriptRoot/../shared/_shared.psm1"

function Move-Cursor([int]$x, [int]$y) {
    $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y }
}

function Clear-Exit() {
    [console]::CursorVisible = $true
    Clear-Host
    exit 0
}

function Update-UI() {
    $cursor = @{ X = 0; Y = 0 }
    $currentPath = $(Get-Location).Path
    $e = "$([char]27)"

    do {
        Clear-Host
        $maxHeight = ($Host.UI.RawUI.BufferSize.Height - 1)

        # Render explorer path
        Write-Host "$e[4m$([char]0xFC6E) $currentPath$e[0m`n"

        # Render files list
        [List[FileSystemInfo]] $files = $(Get-ChildItem -Path $currentPath -Force)
        $currentFile = ""
        $i = 0
        foreach ($file in $files) {
            [string]$drawLine = Get-NameColorized $file
            if ($i -eq $cursor.Y) {
                $drawLine = "$([char]0xF553) $e[4m$drawLine"
                $currentFile = $file.Name
            } else {
                $drawLine = "  $drawLine"
            }
            Write-Host " $drawLine"
            $i++
        }
    
        # Render Help
        Move-Cursor 0 $maxHeight
        Write-Host " ($([char]0xF540)): Move | (Enter): Got to and quit | (q): Quit" -NoNewline
        Move-Cursor $cursor.X $cursor.Y

        # Wait for key
        do {
            # wait for a key to be available:
            if ([Console]::KeyAvailable) {
                # read the key, and consume it so it won't
                # be echoed to the console:
                $keyInfo = [Console]::ReadKey($true)
    
                switch ($keyInfo.Key) {
                    "UpArrow" { 
                        if ($cursor.Y -gt 0) {
                            $cursor.Y--
                        }
                    }
                    "DownArrow" { 
                        if ($cursor.Y -lt ($files.Count - 1)) {
                            $cursor.Y++
                        }
                    }
                    "LeftArrow" {
                        $currentPath = $(Split-Path $currentPath)
                        $cursor.Y = 0
                    }
                    "RightArrow" {
                        $currentPath += "\$($currentFile)"
                        $cursor.Y = 0
                    }
                    "Enter" {
                        $currentPath += "\$($currentFile)"
                        Set-Location $currentPath
                        Clear-Exit
                    }
                    "q" { Clear-Exit }
                    Default {}
                }
                break
            }
        } while ($true)
    } while ($true)
}


Update-UI