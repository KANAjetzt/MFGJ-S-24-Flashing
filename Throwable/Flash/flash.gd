class_name Flash
extends RigidBody3D

signal flashed(flash: Flash, bodies_in_range: Array[Flashable])

var bodies_in_range: Array[Flashable] = []

@onready var timer_detonate: Timer = %TimerDetonate
@onready var flash_radius: Area3D = %FlashRadius
@onready var sfx: AudioStreamPlayer3D = %SFX
@onready var particles_explosion: GPUParticles3D = %ParticlesExplosion
@onready var light_explosion: OmniLight3D = %LightExplosion
@onready var shell: Node3D = %Shell
@onready var flash_collision: CollisionShape3D = %FlashCollision


func start_detonation_timer() -> void:
	timer_detonate.start()


func _on_timer_detonate_timeout() -> void:
	light_explosion.show()
	flash_radius.monitoring = true
	var overlap := flash_radius.get_overlapping_bodies()
	await get_tree().create_timer(0.1).timeout
	flash_radius.monitoring = false
	sfx.pitch_scale = randf_range(0.85, 1.25)
	sfx.play()
	particles_explosion.emitting = true
	flashed.emit(self, bodies_in_range)
	flash_collision.disabled = true
	shell.hide()
	flash_radius.hide()
	light_explosion.hide()
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _on_flash_radius_body_entered(body: Node3D) -> void:
	if body is Flashable:
		bodies_in_range.push_back(body)
		print("peng!")
		print(bodies_in_range.size())


func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		var hit_enemy: Enemy = body
		hit_enemy.flash()
