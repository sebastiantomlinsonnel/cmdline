<#
.SYNOPSIS
Makes one GIF per scene of the demo showcase, with VHS.

.DESCRIPTION
Compiles example/main.dart, times each scene, and records it with VHS
(https://github.com/charmbracelet/vhs) into doc/demo-<number>-<name>.gif.
Nothing is screen recorded: VHS runs the demo in a hidden terminal.

Needs vhs on your PATH: winget install charmbracelet.vhs
(it also needs ttyd and ffmpeg).

.PARAMETER Scenes
Which scenes to make, like -Scenes 2,5. Makes all of them when left out.

.PARAMETER Theme
The VHS colour theme. Run "vhs themes" to see them all.

.EXAMPLE
./scripts/generate_gifs.ps1
./scripts/generate_gifs.ps1 -Scenes 3
#>
param(
    [int[]] $Scenes,
    [string] $Theme = 'Catppuccin Mocha'
)

$ErrorActionPreference = 'Stop'

# Must match the order of _scenes in example/main.dart.
$names = @('logging', 'styling', 'progress', 'tables', 'files', 'shell')

# How the GIFs look. 90 columns fit the longest line (dart --version).
$fontSize = 20
$width = 1180
$height = 650

$root = Split-Path $PSScriptRoot -Parent
$work = Join-Path $root '.dart_tool/demo_gifs'
$exe = Join-Path $work 'demo.exe'

if (-not (Get-Command vhs -ErrorAction SilentlyContinue))
{
    throw 'vhs is not installed. Install it with: winget install charmbracelet.vhs'
}

if (-not $Scenes)
{
    $Scenes = 1..$names.Count
}
foreach ($number in $Scenes)
{
    if ($number -lt 1 -or $number -gt $names.Count)
    {
        throw "There is no scene $number. Pick from 1 to $( $names.Count )."
    }
}

New-Item -ItemType Directory -Force $work | Out-Null
New-Item -ItemType Directory -Force (Join-Path $root 'doc') | Out-Null

Push-Location $root
try
{
    Write-Host 'Compiling the demo...'
    dart compile exe example\main.dart -o $exe | Out-Null
    if ($LASTEXITCODE -ne 0)
    {
        throw 'Compiling example/main.dart failed.'
    }

    foreach ($number in $Scenes)
    {
        $name = $names[$number - 1]
        $gif = "doc/demo-$number-$name.gif"

        # Run the scene once to see how long the GIF should be.
        $time = Measure-Command { & $exe -S $number *> $null }
        $length = [math]::Ceiling($time.TotalMilliseconds) + 500

        # The command is typed while hidden, so each GIF opens on the scene.
        # --hold keeps the last frame still, so the prompt never shows.
        $tape = @"
Output "$gif"
Set Shell "pwsh"
Set FontSize $fontSize
Set Width $width
Set Height $height
Set Padding 24
Set Theme "$Theme"

Hide
Type "./.dart_tool/demo_gifs/demo.exe -S $number --hold"
Enter
Sleep 300ms
Show
Sleep ${length}ms
"@
        $tapeFile = Join-Path $work "scene-$number.tape"
        Set-Content -Path $tapeFile -Value $tape -Encoding utf8NoBOM

        Write-Host "Recording $gif ($([math]::Round($length / 1000, 1) )s)..."
        vhs $tapeFile
        if ($LASTEXITCODE -ne 0)
        {
            throw "VHS failed on scene $number."
        }
    }
}
finally
{
    Pop-Location
}

Write-Host "Done. The GIFs are in doc/."
