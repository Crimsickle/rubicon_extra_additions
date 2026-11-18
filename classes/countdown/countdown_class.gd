@tool
class_name RubiconLevelCountdown
extends Node

var animation_name : String = "scene" ## The name of the animation that the clock animationplayer is using for the current song

var _level : RubiconLevel

signal countdown_finished

func begin_countdown() -> void:
	if !_level or !_level.clock or !_level.clock.animation_player:
		return
	
	await get_tree().create_timer(3.0, false, false, false).timeout
	
	countdown_finished.emit()

func play_song() -> void:
	if !_level or !_level.clock or !_level.clock.animation_player:
		return
	
	if _level.clock.animation_player.has_animation(animation_name):
		_level.clock.animation_player.play(animation_name)

func _ready() -> void:
	if countdown_finished.is_connected(play_song) == false:
		countdown_finished.connect(play_song)
	
	if Engine.is_editor_hint() == false:
		begin_countdown()


func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary] = []
	
	if _level and _level.clock and _level.clock.animation_player:
		properties.append({
			name = "animation_name",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = ",".join(_level.clock.animation_player.get_animation_list()),
		})
	
	return properties

func _notification(notif : int) -> void:
	match notif:
		NOTIFICATION_PARENTED:
			var parent : Node = get_parent()
			if parent is RubiconLevel:
				_level = parent
