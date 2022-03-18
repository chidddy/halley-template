cmake_minimum_required (VERSION 3.10)

# setup VCPKG
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake CACHE STRING "Vcpkg toolchain file")

# halley engine path
set(HALLEY_PATH ${CMAKE_CURRENT_SOURCE_DIR}/halley CACHE STRING "Path to Halley root")

# setup ShaderConductor
set(ShaderConductor_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/ShaderConductor/Include CACHE STRING "Path to ShaderConstructor Include dir")
set(ShaderConductor_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/ShaderConductor/Build/ninja-win-vc143-x64-Release/lib/ShaderConductor.lib CACHE STRING "Path to ShaderConstructor Lib dir")

# setup compile settings
set(Boost_USE_STATIC_LIBS 1)
set(BUILD_HALLEY_TOOLS 1)
set(BUILD_HALLEY_LAUNCHER 1)
set(BUILD_HALLEY_TESTS 0)
set(HALLEY_PROJECT_EMBED 1)
set(HOTRELOAD 0 CACHE BOOL "Sets whether to hot-reload this project")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${HALLEY_PATH}/cmake/")

project (halleyGame)

include(HalleyProject)

if(NOT (DEFINED HALLEY_GAME_BIN_DIR))
	set(HALLEY_GAME_BIN_DIR "bin")
endif()

set (SOURCES
	"prec.cpp"
	"src/game.cpp"
	"src/game_stage.cpp"
	)

set (HEADERS
	"prec.h"
	"src/game.h"
	"src/game_stage.h"
	)

set (GEN_DEFINITIONS
	)

halleyProject(halleyGame "${SOURCES}" "${HEADERS}" "" "${GEN_DEFINITIONS}" ${CMAKE_CURRENT_SOURCE_DIR}/${HALLEY_GAME_BIN_DIR})
