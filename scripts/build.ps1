# building halley and the game

Push-Location build

ninja halley/all

Pop-Location

Push-Location halley\bin

./halley-cmd.exe import ../../ ../../halley

Pop-Location

Push-Location build

ninja halleyGame
ninja halleyGame-dll

Pop-Location