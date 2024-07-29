extends Node3D


@onready var flash_container: Node = %FlashContainer
@onready var player: Player = %Player


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.is_world_ready = true
	Global.flash_container = flash_container

	player.take()
	player.throw.connect(_on_player_throw)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_capture"):
		if Global.is_mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Global.is_mouse_locked = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Global.is_mouse_locked = true


func _on_player_throw(flash: Flash, origin: Vector3, force: Vector3) -> void:
	flash.global_position = origin
	flash_container.add_child(flash)
	flash.freeze = false
	flash.apply_impulse(force, origin)
	await get_tree().create_timer(0.25).timeout
	player.take()
