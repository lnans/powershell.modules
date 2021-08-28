# Return date like Fri 4 Jun 12:54:05 2021 with color
function Get-DateTimeColorized([System.DateTime] $Date) {
    $e = "$([char]27)"
    $timeFormat = (Get-Culture "en-US").DateTimeFormat
    $day = $Date.Day
    $day = $day.toString().Length -eq 1 ? " $day" : $day
    $dayName = $timeFormat.GetDayName($Date.DayOfWeek).Substring(0,3)
    $monthName = $timeFormat.GetMonthName($Date.Month).Substring(0,3)
    $year = $Date.Year
    $time = $Date.ToString("HH:mm:ss")

    return "$e[38;5;36m$dayName $day $monthName $time $year$e[0m"
}

# Return file system mode with colors
function Get-ModeColorized([String] $Mode) {
    $result = ""
    $e = "$([char]27)"
    foreach($char in [char[]]$Mode) {
        switch ($char) {
            "d" { $result += "$e[94m$char" }
            "l" { $result += "$e[96m$char" }
            "a" { $result += "$e[92m$char" }
            "r" { $result += "$e[91m$char" }
            "h" { $result += "$e[93m$char" }
            "s" { $result += "$e[91m$char" }
            Default { $result += $char }
        }
    }
    $result = $result -replace "^-", "$e[92m.$e[0m"
    $result = $result -replace "-", "$e[38;5;243m-$e[0m"
    return $result
}

# Return human readable bytes size with colors
function Get-ReadableBytesColorized([long] $Bytes) {
    $suffix = "B ", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $index = 0
    $e = "$([char]27)"
    while ($Bytes -gt 1kb) 
    {
        $Bytes = $Bytes / 1kb
        $index++
    } 

    $result = "{0:N1} {1}" -f $Bytes, $suffix[$index]

    $missingLength = ""
    for($i = $result.Length; $i -lt 10; $i++) {
        $missingLength += " "
    }

    return "$e[93m$missingLength$result$e[0m"
}

# Return file system name with colors and icons
function Get-NameColorized([System.IO.FileSystemInfo] $fileSystem) {
    $result = ""
    $e = "$([char]27)"
    $isDir = $fileSystem -is [System.IO.DirectoryInfo]
    $isLink = $fileSystem.LinkType.Length -gt 0

    if ($isDir -and $isLink) {
        $result += "$e[96m$([char]0xF751)"
    } elseif ($isDir) {
        $result += "$e[94m$([char]0xF115)"
    } elseif ($isLink) {
        $result += "$e[96m$([char]0xF016)"
    } else {
        $result += "$e[92m"
        $ext = $fileSystem.Extension
        switch ($ext) {
            ".psm1"      { $result += "$([char]0xE7A2)" }
            ".ps1"       { $result += "$([char]0xE7A2)" }
            ".sh"        { $result += "$([char]0xE7A2)" }
            ".ini"       { $result += "$([char]0xF423)" }
            ".config"    { $result += "$([char]0xF423)" }
            ".json"      { $result += "$([char]0xE60B)" }
            ".js"        { $result += "$([char]0xF898)" }
            ".cs"        { $result += "$([char]0xF81A)" }
            ".py"        { $result += "$([char]0xE73C)" }
            ".md"        { $result += "$([char]0xE73E)" }
            ".crt"       { $result += "$([char]0xF623)" }
            ".key"       { $result += "$([char]0xF43D)" }
            ".gitignore" { $result += "$([char]0xE702)" }
            ".sln"       { $result += "$([char]0xE70C)" }
            ".csproj"    { $result += "$([char]0xE70C)" }
            ".lock"      { $result += "$([char]0xF840)" }
            ".vue"       { $result += "$([char]0xFD42)" }
            ".ttf"       { $result += "$([char]0xF031)" }
            ".otf"       { $result += "$([char]0xF031)" }
            ".css"       { $result += "$([char]0xF13C)" }
            ".scss"      { $result += "$([char]0xF13C)" }
            ".sass"      { $result += "$([char]0xF13C)" }
            ".html"      { $result += "$([char]0xE60E)" }
            ".ico"       { $result += "$([char]0xF03E)" }
            ".png"       { $result += "$([char]0xF03E)" }
            ".jpg"       { $result += "$([char]0xF03E)" }
            ".jpeg"      { $result += "$([char]0xF03E)" }
            ".gif"       { $result += "$([char]0xF03E)" }
            Default {
                $result += "$([char]0xF016)"
            }
        }
    }

    $result += " $($fileSystem.Name)"

    if ($isLink) {
        $result += " $([char]0xF553) $($fileSystem.Target)"
    }

    return "$result$e[0m"

}

function Get-ChildItemColorized {
    try {
        # Run Command
        [System.Collections.Generic.List[System.IO.FileSystemInfo]]$list = $(Get-ChildItem -Force | Sort-Object)

        # Get directories and files separately
        $directories = New-Object 'System.Collections.Generic.List[System.IO.FileSystemInfo]'
        $files = New-Object 'System.Collections.Generic.List[System.IO.FileSystemInfo]'
        foreach($item in $list) {
            if ($item -is [System.IO.DirectoryInfo]) {
                $directories.Add($item)
            } else {
                $files.Add($item)
            }
        }
        $list.Clear()
        $list.AddRange($directories)
        $list.AddRange($files)

        $result = ""
        foreach ($item in $list) {
            $mode = Get-ModeColorized $item.Mode
            $size = $item -is [System.IO.FileInfo] ? (Get-ReadableBytesColorized $item.Length) : "          "
            $time = Get-DateTimeColorized $item.LastWriteTime
            $name = Get-NameColorized $item

            $result += "$mode $size $time $name`n"
        }

        Write-Host "`n$result"
    }
    catch {
        Write-Error $_.Exception.Message
    }
}

Export-ModuleMember -Function Get-ChildItemColorized