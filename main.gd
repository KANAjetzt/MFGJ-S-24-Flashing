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
	player.is_input_disabled = true

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
		Utils.toggle_mouse_lock()

	if event.is_action_pressed("debug_0"):
		Global.current_arena.ref.fade_in_level()

	if Global.camera_is_tweening and event.is_action_pressed("skip"):
		Global.player.activate_camera()


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
	var flashed_bodies_count := 0
	
	for flashed_body in flashed_bodies:
		var has_been_flashed_before := flashed_body.is_flashed
		
		var is_flashed := flashed_body.check_sight(flash.global_position)
		if is_flashed and not has_been_flashed_before and flashed_body is not Player:
			flashed_bodies_count = flashed_bodies_count + 1
	
	if flashed_bodies_count > 0:
		Global.current_arena.score_add_enemy(flashed_bodies_count)
	
	Global.current_arena.flashes_used += 1
