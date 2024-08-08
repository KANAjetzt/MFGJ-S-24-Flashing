@tool
class_name PropWall
extends StaticBody3D

@export var use_particles := true :
	set(new_value):
		use_particles = new_value
		if get_node_or_null("%GPUParticles3D"):
			if use_particles == false:
				%GPUParticles3D.emitting = false
				%MeshInstance3D.show()
			else:
				%GPUParticles3D.emitting = true
				%MeshInstance3D.hide()
@export var wall_width := 5.0 :
	set(new_value):
		wall_width = new_value
		%MeshInstance3D.mesh.size.x = new_value
		%CollisionShape3D.shape.size.x = new_value
		%GPUParticlesCollisionBox3D.size.x = new_value
		if use_particles:
			scale_particle_emission_shape()
			update_particle_count()
			update_particle_aabb()
@export var wall_height := 2.7 :
	set(new_value):
		wall_height = new_value
		%MeshInstance3D.mesh.size.y = new_value
		%CollisionShape3D.shape.size.y = new_value
		%GPUParticlesCollisionBox3D.size.y = new_value
		if use_particles:
			scale_particle_emission_shape()
			update_particle_count()
			update_particle_aabb()
@export var wall_depth := 0.3 :
	set(new_value):
		wall_depth = new_value
		%MeshInstance3D.mesh.size.z = new_value
		%CollisionShape3D.shape.size.z = new_value
		%GPUParticlesCollisionBox3D.size.z = new_value
		if use_particles:
			scale_particle_emission_shape()
			update_particle_count()
			update_particle_aabb()

const DEFAULT_SIZE: Vector3 = Vector3(5.0, 2.7, 0.3)
const DEFAULT_PARTICLE_COUNT := 2048

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func scale_particle_emission_shape() -> void:
	var current_size := Vector3(wall_width, wall_height, wall_depth)
	var scale_factors := current_size / DEFAULT_SIZE
	%GPUParticles3D.process_material.emission_shape_scale = scale_factors


func update_particle_count() -> void:
	var current_volume = wall_width * wall_height * wall_depth
	var default_volume = DEFAULT_SIZE.x * DEFAULT_SIZE.y * DEFAULT_SIZE.z
	
	%GPUParticles3D.process_material.emission_point_count = round(DEFAULT_PARTICLE_COUNT * (current_volume / default_volume))
	%GPUParticles3D.amount = round(DEFAULT_PARTICLE_COUNT * (current_volume / default_volume))


func update_particle_aabb() -> void:
	%GPUParticles3D.visibility_aabb = %MeshInstance3D.get_aabb()
	

func play_fade_in() -> void:
	animation_player.play("fade_in")
