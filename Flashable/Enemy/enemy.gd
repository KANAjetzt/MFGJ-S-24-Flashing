class_name Enemy
extends Flashable


@onready var body_parts: Node3D = %BodyParts


func _ready() -> void:
	flashed.connect(_on_flashed)


func unfreeze() -> void:
	for node in body_parts.get_children():
		var body_part: RigidBody3D = node
		body_part.freeze = false;
		body_part.apply_impulse(
			Vector3(
				randf_range(0.0, 1.0),
				randf_range(0.0, 1.0),
				randf_range(0.0, 1.0),
			), 
			body_part.global_position
		)


func _on_flashed(first_time: bool) -> void:
	if first_time:
		unfreeze()
