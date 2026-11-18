@tool
class_name PauseMenu
extends CanvasLayer

var current_paused : bool = false

@export var horizontal_input : bool = false
@export var key_input_reversed : bool = false

@export_group("Buttons", "button_")
@export var button_mouse_input : bool = true
@export var button_keyboard_input : bool = true
@export var button_scene : PackedScene
@export var button_container : BoxContainer
@export var button_info : Array[PauseButtonData] :
	set(value):
		button_info = value
		update_button_info()

var current_buttons : Array[PauseButton] = []
@export_group("Editor", "editor_")

@export var selected_button : int = -1 :
	set(value):
		if button_valid(selected_button) == true:
			current_buttons.get(selected_button).unhover()
		
		if value >= current_buttons.size() and selected_button <= (current_buttons.size() - 1):
			selected_button = 0
		elif value < 0 and selected_button >= 0:
			selected_button = current_buttons.size() - 1
		else:
			selected_button = value
		
		if button_valid(selected_button) == true:
			current_buttons.get(selected_button).hover()

func button_valid(index : int) -> bool:
	return selected_button > -1 and selected_button <= (current_buttons.size() - 1) and current_buttons.get(selected_button) != null


func draw_buttons():
	clear_buttons()
	
	var current_index : int = 0
	
	for info in button_info:
		var new_button : PauseButton = button_scene.instantiate()
		new_button.button_index = current_index
		new_button.pause_menu = self
		new_button.current_text = info.button_text
		
		button_container.add_child(new_button)
		
		current_buttons.append(new_button)
		current_index += 1

func clear_buttons():
	for button in current_buttons:
		if is_instance_valid(button) == true and button.is_queued_for_deletion() == false:
			button.queue_free()
	
	current_buttons.clear()


func update_button_info():
	var index : int = 0
	
	for info in button_info:
		if info and is_instance_valid(info) == true and info.is_queued_for_deletion() == false:
			info.index = index
			info.pause_menu = self
		
		index += 1

func pause():
	selected_button = 0
	
	current_paused = true
	visible = true
	get_tree().paused = true

func unpause():
	current_paused = false
	visible = false
	get_tree().paused = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 999
	update_button_info()
	
	if Engine.is_editor_hint() == false:
		draw_buttons()
		unpause()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed == false:
			return
		
		if current_paused == false:
			if event.keycode == SettingsList.game_pause:
				pause()
		else:
			var mult : int = 1
			if key_input_reversed == true: mult = -1
			
			if (horizontal_input == true and event.keycode == SettingsList.menu_left) or (horizontal_input == false and event.keycode == SettingsList.menu_up):
				selected_button -= 1 * mult
			elif (horizontal_input == true and event.keycode == SettingsList.menu_right) or (horizontal_input == false and event.keycode == SettingsList.menu_down):
				selected_button += 1 * mult
			
			if event.keycode == SettingsList.menu_confirm:
				if button_valid(selected_button) == true and button_info.get(selected_button) != null and has_method(button_info.get(selected_button).button_function) == true:
					call(button_info.get(selected_button).button_function)
