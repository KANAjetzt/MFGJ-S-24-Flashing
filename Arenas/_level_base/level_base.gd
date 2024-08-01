class_name LevelBase
extends Node3D


@export var level_data: LevelData

@onready var start_point: Node3D = %StartPoint
@onready var player_dummy: MeshInstance3D = %PlayerDummy
@onready var enemies: Node3D = %Enemies
@onready var structures: Node3D = %Structures


func _ready() -> void:
	level_data.ref = self
	level_data.start_transform = start_point.global_transform
	level_data.enemy_count = enemies.get_child_count()
	
	player_dummy.hide()
	
	for enemy in enemies.get_children():
		enemy.flashed.connect(_on_enemy_flashed)


func _on_portal_exit_flash_hit_detected(destination_transform: Transform3D) -> void:
	Global.player.teleport(destination_transform)


func _on_enemy_flashed(is_first: bool) -> void:
	if is_first:
		level_data.enemies_flashed_count += 1


func fade_in_level() -> void:
	for structure in structures.get_children():
		if structure is PropWall:
			structure.play_fade_in()
