# halley-template

An attempt at making a simple halley template based on the one provided in the repo
with simple instructions to get it running

**please note that while this is for windows only right now the only thing that needs to be made are scripts for linux/mac, i'm not at home im on a windows laptop so when i am home i will add those**

## dependencies
**pre-requisites:**
* [CMake](https://www.cmake.org/download/) (version 3.10+)
* [Python](https://www.python.org/downloads/) (version 2.7+)
* [Ninja](https://ninja-build.org/) (recommended install via chocolatey)
* [Visual Studio](https://visualstudio.microsoft.com/downloads/) (recommend version 2022, however 2017+ works, this is only for the MSVC compiler)

## instructions

clone this repo and then set up the required submodules

```shell
cd halley-template
git submodule update --init --recursive
```

it is recommended you change the halley submodule to use your own fork 
(probably of my version of the repository as it has SDL include changes to fix issues with VCPKG includes)
to do this simply run

```shell
git submodule set-url halley <your fork url>
```
### windows:


allow execution of unsigned powershell scripts

```shell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

simply run the init script, then the cmake and build scripts in that order
- if you change/add any assets in assets_src or modify/add any components in gen_src (local gen_src not halley/gen_src) you will need to run the assets script
- if you modify/add any components in gen_src you will also need to build again

```shell
./scripts/init.ps1
./scripts/cmake.ps1 (-build_type Debug/Release/RelwithDebInfo) (-clean)
./scripts/build.ps1
./scripts/asset.ps1 (optional if required as described above)
```

## vscode

if you would like to set up vscode for this project, i recommend using these (or similar) settings in your ./vscode/c_cpp_properties.json

**again sorry linux/mac users i will update this when i get home, although the only changes would be to the includePath and intelliSenseMode**

i cannot recommend using the cmake extension for vscode as i've had issues with it creating this, although i didn't put much effort into setting it up

```json
{
    "configurations": [
        {
            "name": "Win32",
            "includePath": [
                "${workspaceFolder}/halley/include/",
                "${workspaceFolder}/halley/src/engine/**",
                "${workspaceFolder}/build/vcpkg_installed/x64-windows/include/**"
            ],
            "intelliSenseMode": "windows-msvc-x64",
            "cStandard": "c17",
            "cppStandard": "c++17",
            "compileCommands": "${workspaceFolder}/build/compile_commands.json"
        }
    ],
    "version": 4
}
```

## notes
**reminder if you need to change your MSVC version either edit/remove the vsconfig file**

**reminder after doing anything in gen_src and assets_src you must compile assets**

**reminder after doing anything in gen_src you'll need to build the project again**

**reminder to update source files in CMakeLists.txt whenever adding new files**
