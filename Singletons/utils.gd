extends Node


func toggle_mouse_lock() -> void:
	if Global.is_mouse_locked:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.is_mouse_locked = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.is_mouse_locked = true
