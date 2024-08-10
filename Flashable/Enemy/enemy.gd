class_name Enemy
extends Flashable


@onready var body_parts: Node3D = %BodyParts
@onready var sfx_dying: AudioStreamPlayer3D = %SFXDying


func _ready() -> void:
	flashed.connect(_on_flashed)


func unfreeze() -> void:
	for node in body_parts.get_children():
		var body_part: RigidBody3D = node
		body_part.freeze = false;
		body_part.apply_impulse(
			Vector3(
				randf_range(-1.0, 1.0),
				randf_range(-1.0, 1.0),
				randf_range(-1.0, 1.0),
			), 
			body_part.global_position
		)
		sfx_dying.pitch_scale = randf_range(0.8, 1.2)
		sfx_dying.play()

func _on_flashed(first_time: bool) -> void:
	if first_time:
		unfreeze()
