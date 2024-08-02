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
var player: Player
var current_arena: LevelData
var current_arena_index := 0 :
	set(new_value):
		current_arena_index = new_value
		current_arena = arenas[new_value]

var camera: Camera3D
var active_camera: PhantomCamera3D :
	set(new_value):
		if active_camera:
			prevoius_camera = active_camera
		active_camera = new_value
		active_camera.set_priority(1)
		
var prevoius_camera: PhantomCamera3D = null :
	set(new_value):
		prevoius_camera = new_value
		prevoius_camera.set_priority(0)


func blend() -> void:
	%AnimationPlayer.play("blend")
