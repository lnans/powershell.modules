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

Export-ModuleMember -Function Get-NameColorized
