@tool
class_name PauseButton
extends Control

@export var current_text : String = "NULL" :
	set(value):
		current_text = value
		update()

@export var label : Label

var button_index : int = -1
var pause_menu : PauseMenu
var hovered : bool = false

func hover():
	if hovered == true:
		return
	
	hovered = true

func unhover():
	if hovered == false:
		return
	
	hovered = false

func update():
	if label:
		label.text = current_text

func _ready() -> void:
	update()
	unhover()
