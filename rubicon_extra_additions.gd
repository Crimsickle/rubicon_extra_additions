@tool
extends EditorPlugin

const SETTINGS_LIST_PATH : String = "res://addons/rubicon_extra_aditions/classes/settings/settings_list.gd"
const SETTINGS_GLOBAL_PATH : String = "res://addons/rubicon_extra_aditions/classes/settings/settings_global.gd"

func _enter_tree() -> void:
	add_autoload_singleton("SettingsList", SETTINGS_LIST_PATH)
	add_autoload_singleton("SettingsGlobal", SETTINGS_GLOBAL_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton("SettingsList")
	remove_autoload_singleton("SettingsGlobal")
