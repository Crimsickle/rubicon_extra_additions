extends Node

## Visual ##

var max_fps : int = 120
var vsync : bool = true
var flashing_lights : bool = true
var shaders : bool = true
var auto_pause : bool = true

## Inputs ##

var menu_up : Key = KEY_UP
var menu_down : Key = KEY_DOWN
var menu_left : Key = KEY_LEFT
var menu_right : Key = KEY_RIGHT
var menu_confirm : Key = KEY_ENTER
var menu_back : Key = KEY_ESCAPE

var game_pause : Key = KEY_ENTER

var game_key0 : Key = KEY_D
var game_key1 : Key = KEY_F
var game_key2 : Key = KEY_J
var game_key3 : Key = KEY_K

# Developer settings

var debug_stats : Key = KEY_F1
var console : Key = KEY_F2
var reload_scene : Key = KEY_F5
