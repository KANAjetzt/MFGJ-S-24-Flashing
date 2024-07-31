class_name Flashable
extends CharacterBody3D

signal flashed(first_time)

@export var is_flashed := false

@onready var ray_cast: RayCast3D = %RayCast


func check_sight(target_position: Vector3) -> void:
	ray_cast.enabled = true
	ray_cast.target_position = to_local(target_position)
	ray_cast.target_position -= ray_cast.position
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		print("WALL!")
	else:
		print("MY EYES X_X")
		flashed.emit(not is_flashed)
		is_flashed = true
	ray_cast.enabled = false
