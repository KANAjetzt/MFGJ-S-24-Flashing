extends Node3D


@onready var flash_container: Node = %FlashContainer
@onready var player: Player = %Player
@onready var start_point_level_selection: Node3D = $LevelSelection/StartPoint
@onready var camera: Camera3D = %Camera
@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D
@onready var level_selection: LevelBase = %LevelSelection
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var levels: Node3D = %Levels


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.flash_container = flash_container
	Global.level_container = levels
	Global.camera = camera
	
	player.teleport(start_point_level_selection.global_transform)
	player.take()
	
	Global.is_world_ready = true
	
	if Global.disable_intro:
		player.activate_camera()
	else:
		level_selection.activate_camera()
	
	for node in levels.get_children():
		var level: LevelBase = node
		level.level_data.main_transform = level.global_transform
		levels.remove_child(level)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_capture"):
		if Global.is_mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Global.is_mouse_locked = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Global.is_mouse_locked = true
	
	if event.is_action_pressed("debug_0"):
		Global.current_arena.ref.fade_in_level()


func _on_player_throw_before(flash: Flash, origin: Vector3, force: Vector3) -> void:
	flash.flashed.connect(_on_flash_flashed)
	flash.start_detonation_timer()


func _on_player_throw(flash: Flash, origin: Vector3, force: Vector3) -> void:
	flash_container.add_child(flash)
	flash.global_position = origin
	flash.freeze = false
	flash.apply_impulse(force, origin)
	player.take()


func _on_flash_flashed(flash: Flash, flashed_bodies: Array[Flashable]) -> void:
	for flashed_body in flashed_bodies:
		flashed_body.check_sight(flash.global_position)
