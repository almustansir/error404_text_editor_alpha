extends Control

var app_name = "Eror404 Text Editor"
var current_file = "Untitled"

func _ready():
	update_window_title()
	for i in ["New File","Open File","Save","Save as File","Quit"]:
		$MenuButtonFile.get_popup().add_item(i)
	
	$MenuButtonFile.get_popup().set_item_shortcut(4, set_shortcut(KEY_Q), true)
	
	$MenuButtonHelp.get_popup().add_item("About")
	
	# signals
	$MenuButtonFile.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$MenuButtonHelp.get_popup().connect("id_pressed", self, "_on_item_help_pressed")
	
func update_window_title():
	OS.set_window_title(app_name + ' - '+current_file)

func set_shortcut(key):
	var shortcut = ShortCut.new()
	var inputeventkey = InputEventKey.new()
	inputeventkey.set_scancode(key)
	inputeventkey.control = true
	shortcut.set_shortcut(inputeventkey)
	return shortcut

func new_file():
	current_file = "Untitled"
	update_window_title()
	$TextEdit.text = ''

func save_file():
	var path = current_file
	if path == 'Untitled':
		$SaveFileDialog.popup()
	else:
		var f = File.new()
		f.open(path, 2)
		f.store_string($TextEdit.text)
		f.close()
		update_window_title()
	

func _on_item_pressed(id):
	var item_name = $MenuButtonFile.get_popup().get_item_text(id)
	match item_name:
		'New File':
			new_file()
		'Open File':
			$OpenFileDialog.popup()
		'Save':
			save_file()
		'Save as File':
			$SaveFileDialog.popup()
		'Quit':
			get_tree().quit()
	
func _on_item_help_pressed(id):
	var item_name = $MenuButtonHelp.get_popup().get_item_text(id)
	if item_name == 'About':
		$AboutDialog.popup()

func _on_OpenFile_pressed():
	$OpenFileDialog.popup()

func _on_SaveFile_pressed():
	$SaveFileDialog.popup()


func _on_OpenFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, 1)
	$TextEdit.text = f.get_as_text()
	f.close()
	current_file = path
	update_window_title()


func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()
	current_file = path
	update_window_title()

