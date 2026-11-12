@tool
extends EditorPlugin

const SETTINGS_GLOBAL_PATH : String = "res://addons/rubicon_extra_aditions/classes/settings/settings_global.gd"

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	add_autoload_singleton("SettingsGlobal", SETTINGS_GLOBAL_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton("SettingsGlobal")
