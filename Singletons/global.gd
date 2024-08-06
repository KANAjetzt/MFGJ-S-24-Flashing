extends Node


signal world_ready

@export var arenas: Array[LevelData]
@export var settings: SettingsData
@export var score_data: ScoreData

@export_group("Debug")
@export var disable_intro := false

var is_world_ready := false :
	set(new_value):
		is_world_ready = new_value
		if new_value == true:
			world_ready.emit()
var is_mouse_locked := true
var flash_container: Node
var level_container: Node3D
var player: Player

var current_arena: LevelData :
	set(new_value):
		previous_arena = current_arena
		current_arena = new_value
		current_arena.is_active = true
var current_arena_index := 0 :
	set(new_value):
		current_arena_index = new_value
		current_arena = arenas[new_value]
var previous_arena: LevelData = null :
	set(new_value):
		previous_arena = new_value
		if previous_arena:
			previous_arena.is_active = false

var camera: Camera3D
var active_camera: PhantomCamera3D :
	set(new_value):
		if active_camera:
			previous_camera = active_camera
		active_camera = new_value
		active_camera.set_priority(1)
		active_camera.is_tweening.connect(_on_camera_is_tweening)
		active_camera.tween_completed.connect(_on_camera_tween_completed)
var previous_camera: PhantomCamera3D = null :
	set(new_value):
		previous_camera = new_value
		previous_camera.set_priority(0)
		previous_camera.is_tweening.disconnect(_on_camera_is_tweening)
		previous_camera.tween_completed.disconnect(_on_camera_tween_completed)
var camera_is_tweening := false

var time_level_start: int
var time_level: int :
	set(new_value) :
		time_level = new_value
		hud.panel_time_level.label_text = hud.format_stopwatch(new_value)
		current_arena.level_current_time = new_value
var time_game: int :
	set(new_value):
		time_game = new_value
		hud.panel_time_game.label_text = hud.format_stopwatch(new_value)


@onready var crosshair: TextureRect = %Crosshair
@onready var hud: UIHUD = %HUD
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _process(delta: float) -> void:
	time_game = Time.get_ticks_msec()

	if time_level_start:
		time_level = time_game - time_level_start


func blend() -> void:
	%AnimationPlayer.play("blend")


func _on_camera_is_tweening() -> void:
	camera_is_tweening = true
	hud.skip_display_fade_in()

func _on_camera_tween_completed() -> void:
	camera_is_tweening = false
	hud.skip_display_fade_out()


func add_flash_score(enemies_flashed: int) -> void:
	pass
