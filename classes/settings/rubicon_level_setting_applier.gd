class_name RubiconLevelSettingApplier
extends Node

@export var note_controllers : Array[RubiconLevelNoteController]

func apply_inputs():
	var input_resource : RubiconLevelNoteInputMap = SettingsGlobal.get_key_inputs()
	
	for controller in note_controllers:
		controller.inputs = input_resource

func _ready() -> void:
	apply_inputs()
	
	SettingsGlobal.settings_updated.connect(func():
		apply_inputs()
	)
