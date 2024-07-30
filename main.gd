extends Node3D


@onready var flash_container: Node = %FlashContainer
@onready var player: Player = %Player
@onready var start_point_level_selection: Node3D = $LevelSelection/StartPoint


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.is_world_ready = true
	Global.flash_container = flash_container
	
	player.teleport(start_point_level_selection.global_position)
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
	flash_container.add_child(flash)
	flash.flashed.connect(_on_flash_flashed)
	flash.global_position = origin
	flash.freeze = false
	flash.apply_impulse(force, origin)
	flash.start_detonation_timer()
	await get_tree().create_timer(0.25).timeout
	player.take()


func _on_flash_flashed(flash: Flash, flashed_bodies: Array[Flashable]) -> void:
	for flashed_body in flashed_bodies:
		flashed_body.check_sight(flash.global_position)
