extends Node


signal world_ready

@export var arenas: Array[LevelData]

var is_world_ready := false :
	set(new_value):
		is_world_ready = new_value
		if new_value == true:
			world_ready.emit()
var is_mouse_locked := true
var flash_container: Node
var player: Player
var current_arena_index := 0
