@tool
class_name PauseButtonData
extends Resource

var pause_menu : PauseMenu
var index : int = 0

@export var button_text : String = "NULL" : ## The text the button displays
	set(value):
		button_text = value
		resource_name = value

var button_function : String = "" ## The function that fires whenever the button gets pressed

func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary] = []
	
	if pause_menu:
		var methods : PackedStringArray = []
		var disregarded_methods : PackedStringArray = []
		
		for method in ClassDB.class_get_method_list("CanvasLayer"):
			disregarded_methods.append(method.name)
		
		for method in pause_menu.get_method_list():
			var method_name : String = method.name
			
			if method_name.length() > 7:
				if (method_name.substr(0, 1) + method_name.substr(method_name.length() - 7, -1)) == "@_setter":
					continue
			
			if disregarded_methods.has(method.name) == false:
				methods.append(method.name)
		
		properties.append({
			"name": "button_function",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(methods),
		})
	
	return properties

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSTINITIALIZE:
			set_resource_name()

func set_resource_name() -> void:
	resource_name = button_text
