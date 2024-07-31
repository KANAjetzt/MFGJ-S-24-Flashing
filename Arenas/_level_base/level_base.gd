class_name LevelBase
extends Node3D


@export var level_data: LevelData

@onready var start_point: Node3D = %StartPoint
@onready var player_dummy: MeshInstance3D = %PlayerDummy
@onready var enemies: Node3D = $Enemies


func _ready() -> void:
	level_data.start_position = start_point.global_position
	level_data.enemy_count = enemies.get_child_count()
	player_dummy.hide()


func _on_portal_exit_flash_hit_detected(destination_position: Vector3) -> void:
	Global.player.teleport(destination_position)
