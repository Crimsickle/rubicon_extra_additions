extends Node

const AUTOSAVE_TIME : int = 60

var data_path : String = OS.get_data_dir() + "/RubiconAdditions"
var setting_path = data_path + "/settings.json"

var autosave_timer : Timer = Timer.new()

func get_settings() -> Dictionary[String, Variant]:
	var properties : Dictionary[String, Variant] = {}
	var property_discards : Array[String] = ["Node", "Process", "Thread Group", "Physics Interpolation", "Auto Translate", "Editor Description", "settings_list.gd"]
	
	for property in SettingsList.get_property_list():
		var prop_name : String = property.name
		if prop_name in self or property_discards.has(prop_name) == true:
			continue
		
		properties[prop_name] = SettingsList.get(prop_name)
	
	return properties

func read_settings() -> void:
	if FileAccess.file_exists(setting_path) == true:
		var file = FileAccess.open(setting_path, FileAccess.READ)
		var string_data = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(string_data)
		if error == OK:
			var new_data : Dictionary[String, Variant] = {}
			var json_data := json.get_data()
			
			for key in json_data:
				var value : Variant = json_data.get(key)
				
				if key in SettingsList:
					SettingsList.set(key, value)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", string_data, " at line ", json.get_error_line())

func write_settings() -> void:
	var json_string = JSON.stringify(get_settings(), "\t")
	
	var file = FileAccess.open(setting_path, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		
		print("JSON file successfully saved to: ", setting_path)
	else:
		print("Error saving file: ", FileAccess.get_open_error())

func _ready() -> void:
	add_child(autosave_timer)
	
	autosave_timer.wait_time = float(AUTOSAVE_TIME)
	autosave_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	autosave_timer.timeout.connect(func():
		write_settings()
	)
	
	autosave_timer.start()
	
	read_settings()
	
	write_settings()
