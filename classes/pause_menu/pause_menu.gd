class_name PauseMenu
extends CanvasLayer


func pause():
	visible = true
	get_tree().paused = true

func unpause():
	visible = false
	get_tree().paused = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
