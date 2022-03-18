
$currentDirectory = (Get-Item .).FullName
function Set-VS {

    
    $currentDirectory = (Get-Item .).FullName

    if(Test-Path -Path $currentDirectory\vsconfig -PathType Leaf){
        Write-Host "Reminder: if you want to change your MSVC version modify vsconfig"
        return
    }

    Write-Host "Which MSVC build version do you want to run?"
    Write-Host "(0) vc143"
    Write-Host "(1) vc142"
    Write-Host "(2) vc141"
    Write-Host "(3) vc140"
    [int]$vsNum = Read-Host "Please select a version"

    if(($null -eq $vsNum)) {
        $vsNum = 0
    }
    elseif(($vsNum -isnot [int])) {
        Write-Error "Please provide a valid version"
        Set-VS
    }


    $HalleyTemplateVSVersion = Switch($vsNum)
    {
        0 {"vc143"}
        1 {"vc142"}
        2 {"vc141"}
        3 {"vc140"}
    }

    New-Item -Path $currentDirectory\vsconfig -ItemType "file" -Value $HalleyTemplateVSVersion

    Write-Host "Using MSVC $HalleyTemplateVSVersion"

}

function Install-ShaderConductor {

    $currentDirectory = (Get-Item .).FullName

    $vsVersion = Get-Content $currentDirectory\vsconfig

    Write-Host "Compiling ShaderConductor with $vsVersion"

    # enter ShaderConductor directory
    Push-Location ShaderConductor

    # clean build
    if ($args[0] -eq "clean") {
        Remove-Item -Recurse Build
    }

    # run provided build script
    python BuildAll.py ninja $vsVersion x64 Release

    # exit ShaderConductor directory
    Pop-Location


    Copy-Item $currentDirectory\ShaderConductor\Build\ninja-win-$vsVersion-x64-Release\Bin\ShaderConductor.dll -Destination $currentDirectory\halley\bin\
    Copy-Item $currentDirectory\ShaderConductor\Build\ninja-win-$vsVersion-x64-Release\Bin\dxcompiler.dll -Destination $currentDirectory\halley\bin\


    Write-Host "ShaderConductor built"
}

Write-Host "Init Begin"
cmd.exe /c `"$currentDirectory\vcpkg\bootstrap-vcpkg.bat`"
Set-VS
Install-ShaderConductor
Write-Host "Init complete"