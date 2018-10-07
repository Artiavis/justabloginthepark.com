<#
.SYNOPSIS
    Alias to run imagemagick with some canned settings to resize an image and create a thumbnail.
.DESCRIPTION
    Alias to run imagemagick with some canned settings to resize an image and create a thumbnail
.NOTES
    Requires : imagemagick
#>

param (
    [Parameter(Mandatory=$true)][ValidateScript({Test-Path $_ -PathType 'Leaf'})][string]$infile,
    [Parameter(Mandatory=$false)][ValidateRange(360, 4000)][int]$maxdimension = 1440,
    [Parameter(Mandatory=$false)][ValidateRange(0, 100)][int]$quality = $null,
    [Parameter(Mandatory=$false)][ValidateRange(1, 100000)][int]$targetkb = $null,
    [Parameter(Mandatory=$false)][switch]$createthumbnail = $false,
    [Parameter(Mandatory=$false)][ValidateRange(1, 1000)][int]$targetthumbnailkb = 50
)

function rename($originalname, $newsuffix) {
    $originalfile = Get-Item $originalname
    $d = $originalfile.DirectoryName
    $f = $originalfile.BaseName
    $e = $originalfile.Extension
    return Join-Path -Path $d -ChildPath "$f-$newsuffix$e"
}

function makeResizeCmd() {
    $cmd = New-Object Collections.Generic.List[object]
    $outfile = rename $infile "resized"
    $cmd.AddRange(@(
        'convert', $infile
    ))
    if ($targetkb) {
        $cmd.AddRange(@('-define', "jpeg:extent=${targetkb}kb"))
    }
    $cmd.AddRange(@(
        '-colorspace', 'sRGB',
        '-resize', "${maxdimension}x${maxdimension}^",
        '-colorspace', 'sRGB'
    ))
    if ($quality) {
        $cmd.AddRange(@('-quality', $quality))
    }
    $cmd.AddRange(@(
        '-unsharp', '0x1',
        $outfile
    ))

    return $cmd.ToArray()
}

function makeThumbCmd() {
    $cmd = New-Object Collections.Generic.List[object]
    $outfile = rename $infile "thumb"
    $cmd.AddRange(@(
        'convert', $infile
    ))
    if ($targetthumbnailkb) {
        $cmd.AddRange(@('-define', "jpeg:extent=${targetthumbnailkb}kb"))
    }
    $cmd.AddRange(@(
        '-colorspace', 'sRGB',
        '-resize', "375x375>",
        '-colorspace', 'sRGB',
        '-unsharp', '0x1',
        $outfile
    ))

    return $cmd.ToArray()
}

$resizeCmd = makeResizeCmd
$thumbCmd = makeThumbCmd

Write-Output "magick.exe $resizeCmd"
& magick.exe $resizeCmd

if ($createthumbnail) {
    Write-Output "magick.exe $thumbCmd"
    & magick.exe $thumbCmd
}
