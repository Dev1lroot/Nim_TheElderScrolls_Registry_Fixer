import os, system, registry, rdstdin, terminal, colors

const HKEY_LOCAL_MACHINE = 2147483650'u;

proc getlocation(name: string):string =
  var o = "Unspecified"
  try:
    setForegroundColor(fgGreen)
    o = getUnicodeValue("SOFTWARE\\Wow6432Node\\Bethesda Softworks\\" & name,"Installed Path",HKEY_LOCAL_MACHINE)
  except:
    setForegroundColor(fgRed)
    o = "Not found"
  return o

proc setup(game: string) =
  echo "Please enter your actual " & game & " location:"
  var x = readLineFromStdin("> ")
  if dirExists($x):
    try:
      setUnicodeValue("SOFTWARE\\Wow6432Node\\Bethesda Softworks\\" & game,"Installed Path", $x ,HKEY_LOCAL_MACHINE)
      setForegroundColor(fgGreen)
      echo game & " path successfully updated"
    except:
      setForegroundColor(fgRed)
      echo "An error occured while updating " & game & " location, insufficient permission or something else\n"
  else:
    setForegroundColor(fgRed)
    echo "The directory you specified does not exists"
  setForegroundColor(fgWhite)

proc specify() =
  echo "============================================================================"
  echo "Choose the game you wish specify location to:"
  echo "============================================================================"
  echo "1) Skyrim"
  echo "2) Skyrim Special Edition"
  echo "3) Oblivion"
  echo "============================================================================"
  var x = readLineFromStdin("> ")
  if x == "1":
    setup("Skyrim")
  if x == "2":
    setup("Skyrim Special Edition")
  if x == "3":
    setup("Oblivion")
  if x != "1" and x != "2" and x != "3":
    echo "Unknown game number, please try again"
  specify()

proc cmdline() =
  var x = readLineFromStdin("> ")
  if $x != "Y" or $x != "y":
    specify()
  if $x != "N" or $x != "n":
    echo "Unknown answer, let's try again!"
    cmdline()
  echo "cannot recognize, terminating"

echo "============================================================================"
echo "Skyrim path                 : " & getlocation("Skyrim")
setForegroundColor(fgWhite)
echo "Skyrim Special Edition path : " & getlocation("Skyrim Special Edition")
setForegroundColor(fgWhite)
echo "Oblivion path               : " & getlocation("Oblivion")
setForegroundColor(fgWhite)
echo "============================================================================"
setForegroundColor(fgYellow)
echo "Would you like to specify paths? (Y/n)"
setForegroundColor(fgWhite)
cmdline()
