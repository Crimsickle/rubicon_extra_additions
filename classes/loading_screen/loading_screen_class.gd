class_name LoadingScreen
extends CanvasLayer

var scene_path : String = ""

func change_scene(path : String):
	scene_path = path

func _scene_swap():
	get_tree().call_deferred("change_scene_to_file", scene_path)
