extends Node


signal world_ready

@export var arenas: Array[LevelData]
@export var settings: SettingsData

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
		
var previous_camera: PhantomCamera3D = null :
	set(new_value):
		previous_camera = new_value
		previous_camera.set_priority(0)

@onready var crosshair: TextureRect = %Crosshair


func _ready() -> void:
	settings.crosshair_color_changed.connect(_on_crosshair_color_changed)


func blend() -> void:
	%AnimationPlayer.play("blend")


func _on_crosshair_color_changed(new_color: Color) -> void:
	crosshair.modulate = new_color
