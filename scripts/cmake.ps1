# cmake generator for halley (windows x64)
param (
    [string]$build_type="Debug",
    [switch]$clean = $false
)

$currentDirectory = (Get-Item .).FullName


if(-not (Test-Path -Path $currentDirectory\vsconfig -PathType Leaf)){
    Write-Host "please run init.ps1 first"
    exit
} else {
    $vsVersion = Get-Content $currentDirectory\vsconfig
}

# recreate build folder (clean build)
if($clean) { 
    Remove-Item -Recurse build
    mkdir build
} elseif (-not(Test-Path -Path $currentDirectory\build)) {
    mkdir build
}

# enter build directory
Push-Location build

# set vcvars provided by visual studio
if(Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\Installer"){
    $vsDir = cmd.exe /c "`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe`" -latest -property installationPath"
} else {
    $vsDir = cmd.exe /c "`"C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe`" -latest -property installationPath"
}

$vcVars = switch($vsVersion) {
    "vc143" {"14.3"}
    "vc142" {"14.2"}
    "vc141" {"14.1"}
    "vc140" {"14.0"}
}

cmd.exe /c "call `"$vsDir\VC\Auxiliary\Build\vcvars64.bat`" --vcvars_ver=$vcVars && set > vcvars.txt"
Get-Content "vcvars.txt" | Foreach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Content "env:\$($matches[1])" $matches[2]
    }
}

cmake -G "Ninja" -DCMAKE_BUILD_TYPE="$build_type" ..


Copy-Item $currentDirectory\build\vcpkg_installed\x64-windows\bin\SDL2.dll -Destination $currentDirectory\halley\bin

# exit build directory
Pop-Location
