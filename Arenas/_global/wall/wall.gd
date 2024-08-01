@tool
class_name PropWall
extends StaticBody3D


@export var wall_width := 5.0 :
	set(new_value):
		wall_width = new_value
		%MeshInstance3D.mesh.size.x = new_value
		%CollisionShape3D.shape.size.x = new_value
		%GPUParticlesCollisionBox3D.size.x = new_value
@export var wall_height := 2.7 :
	set(new_value):
		wall_height = new_value
		%MeshInstance3D.mesh.size.y = new_value
		%CollisionShape3D.shape.size.y = new_value
		%GPUParticlesCollisionBox3D.size.y = new_value
@export var wall_depth := 0.3 :
	set(new_value):
		wall_depth = new_value
		%MeshInstance3D.mesh.size.z = new_value
		%CollisionShape3D.shape.size.z = new_value
		%GPUParticlesCollisionBox3D.size.z = new_value

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func play_fade_in() -> void:
	animation_player.play("fade_in")
