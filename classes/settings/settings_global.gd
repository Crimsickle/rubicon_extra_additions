extends Node

enum setting_types {
	VSYNC,
	MAX_FPS,
	DOWNSCROLL,
	
	KEY_1, KEY_2, KEY_3, KEY_4,
}

const SETTING_DEFAULTS : Dictionary[setting_types, Variant] = {
	setting_types.VSYNC : true,
	setting_types.MAX_FPS : int(120),
	setting_types.DOWNSCROLL : false,
	
	setting_types.KEY_1 : int(KEY_D),
	setting_types.KEY_2 : int(KEY_F),
	setting_types.KEY_3 : int(KEY_J),
	setting_types.KEY_4 : int(KEY_K),
}

const FILE_SECTION_NAME : String = "Settings"
const AUTOSAVE_TIME : int = 60

var data_path : String = OS.get_data_dir() + "/RubiconAdditions"
var setting_path = data_path + "/settings.json"

var new_timer : Timer

var current_settings : Dictionary[setting_types, Variant] = SETTING_DEFAULTS :
	set(value):
		current_settings = value
		settings_updated.emit()

signal settings_updated

func _ready() -> void:
	if DirAccess.dir_exists_absolute(data_path) == false:
		var error = DirAccess.make_dir_recursive_absolute(data_path)
	
	if Engine.is_editor_hint() == true:
		return
	
	new_timer = Timer.new()
	new_timer.one_shot = false
	new_timer.wait_time = float(AUTOSAVE_TIME)
	add_child(new_timer)
	
	new_timer.start()
	
	new_timer.timeout.connect(func():
		write_settings()
	)
	
	var file_settings : Dictionary[setting_types, Variant] = read_settings()
	
	if file_settings != {}:
		current_settings = file_settings
		write_settings()

func write_settings() -> void: # Write settings to file
	var json_string = JSON.stringify(current_settings, "\t")
	
	var file = FileAccess.open(setting_path, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		
		print("JSON file successfully saved to: ", setting_path)
	else:
		print("Error saving file: ", FileAccess.get_open_error())

func read_settings() -> Dictionary[setting_types, Variant]: # Read settings from file
	if FileAccess.file_exists(setting_path) == true:
		var file = FileAccess.open(setting_path, FileAccess.READ)
		var string_data = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(string_data)
		if error == OK:
			var new_data : Dictionary[setting_types, Variant] = {}
			var json_data := json.get_data()
			
			for key in json_data:
				new_data[int(key)] = json_data.get(key)
			
			return new_data
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", string_data, " at line ", json.get_error_line())
	
	return SETTING_DEFAULTS



func set_setting(type : setting_types, value : Variant) -> void:
	current_settings.set(type, value)
	write_settings()


func get_setting(type : setting_types) -> Variant:
	return current_settings.get(type)

func get_all_settings() -> Dictionary[setting_types, Variant]:
	return current_settings

func get_key_inputs() -> RubiconLevelNoteInputMap:
	var new_input_map : RubiconLevelNoteInputMap = RubiconLevelNoteInputMap.new()
	
	for i in 4:
		var new_input_key : InputEventKey = InputEventKey.new()
		new_input_key.keycode = get_setting(setting_types["KEY_" + str(i + 1)])
		new_input_map.inputs[new_input_key] = "mania_lane" + str(i)
	
	return new_input_map
