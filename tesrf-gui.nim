# Uses the latest version of NiGui

import nigui, os, system, registry

const HKEY_LOCAL_MACHINE = 2147483650'u;

proc getlocation(game: string):string =
  var o = "Unspecified"
  try:
    o = getUnicodeValue("SOFTWARE\\Wow6432Node\\Bethesda Softworks\\" & game,"Installed Path",HKEY_LOCAL_MACHINE)
  except:
    o = "Not found"
  return o


app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
container.padding = 16
container.xAlign = XAlign_Center
window.add(container)

var panel_select = newLayoutContainer(Layout_Horizontal)
panel_select.frame = newFrame("Select your game")
panel_select.padding = 4
container.add(panel_select)

var select_game = newComboBox(@["Skyrim", "Skyrim Special Edition", "Oblivion"])
panel_select.add(select_game)
panel_select.widthMode = WidthMode_Expand

var apply = newButton("Apply")
panel_select.add(apply)

var panel_path = newLayoutContainer(Layout_Horizontal)
panel_path.frame = newFrame("Specify Installed Path")
panel_path.padding = 4
container.add(panel_path)

var input_path = newTextBox("")
panel_path.add(input_path)

apply.onClick = proc(event: ClickEvent) =
  if dirExists(input_path.text):
    try:
      setUnicodeValue("SOFTWARE\\Wow6432Node\\Bethesda Softworks\\" & select_game.value,"Installed Path", input_path.text ,HKEY_LOCAL_MACHINE)
    except:
       window.alert("Run it as administrator first!")
  else:
    window.alert("The directory does not exists")

input_path.text = getlocation("Skyrim")
select_game.onChange = proc(event: ComboBoxChangeEvent) =
  input_path.text = getlocation(select_game.value)

var label = newLabel("Dev1lroot (C) 2021")
label.height = 32
container.add(label)

window.height = 240
window.show()

app.run()
