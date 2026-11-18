@tool
extends PauseButton

func hover():
	super()
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func unhover():
	super()
	modulate = Color(0.65, 0.65, 0.65, 1.0)
