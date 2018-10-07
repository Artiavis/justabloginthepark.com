<#
.SYNOPSIS
    Alias to run ffmpeg with some canned settings to convert a video file to a gif.
.DESCRIPTION
    Alias to run ffmpeg with some canned settings to convert a video file to a gif.
.NOTES
    Requires : ffmpeg
.LINK
    https://gist.github.com/stephenlb/decba54c329529c3c807
#>

param (
    [Parameter(Mandatory=$true)][string]$infile,
    [Parameter(Mandatory=$true)][string]$outfile,
    [Parameter(Mandatory=$true)][ValidateRange(1,60)][int]$fps,
    [Parameter(Mandatory=$true)][ValidateRange(360,1080)][int]$resolution,
    [Parameter(Mandatory=$false)][ValidateSet("diff", "full")][string]$statsmode,
    [Parameter(Mandatory=$false)][string]$starttime = $null,
    [Parameter(Mandatory=$false)][string]$duration = $null
)

function makePngCmd() {
    $cmd = New-Object Collections.Generic.List[object]
    $cmd.AddRange(@('-y', '-v', 'warning'))
    if ($starttime) {
        $cmd.AddRange(@('-ss', $starttime))
    }
    if ($duration) {
        $cmd.AddRange(@('-t', $duration))
    }
    $cmd.AddRange(@('-i', $infile, '-vf', $filterString, $paletteFileName))
    return $cmd.ToArray()
}

function makeGifCmd() {
    $cmd = New-Object Collections.Generic.List[object]
    $cmd.AddRange(@('-y', '-v', 'warning'))
    if ($starttime) {
        $cmd.AddRange(@('-ss', $starttime))
    }
    if ($duration) {
        $cmd.AddRange(@('-t', $duration))
    }
    $cmd.AddRange(@('-i', $infile, '-i', $paletteFileName, '-filter_complex', $filterString2, $outfile))
    return $cmd.ToArray()
}

$paletteFileName = [System.IO.Path]::GetTempFileName() + '.png'
$filters = "fps=$fps,scale=${resolution}:-1:flags=lanczos"
$paletteOps = "stats_mode=$statsmode"
$filterString = "$filters,palettegen=$paletteOps"
$filterString2 = "$filters [x]; [x][1:v] paletteuse"
$timingOpts = ""

if ($starttime) {
    $timingOpts = "-ss $starttime"
}
if ($duration) {
    if ($timingOpts) {
        $timingOpts = "$timingOpts -t $duration"
    } else {
        $timingOpts = "-t $duration"
    }
}

$pngCmd = makePngCmd
$gifCmd = makeGifCmd

Write-Output "ffmpeg.exe $pngCmd"
& ffmpeg.exe $pngCmd
Write-Output "ffmpeg.exe $gifCmd"
& ffmpeg.exe $gifCmd
