@tool
extends PauseMenu

func settings():
	pass

func restart():
	get_tree().reload_current_scene()

func menu():
	get_tree().quit()
