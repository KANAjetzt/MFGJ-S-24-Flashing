extends Node3D


var mouse_locked := true


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_capture"):
		if mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_locked = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_locked = true
