class_name Flash
extends RigidBody3D


var bodies_in_range: Array = []

@onready var timer_detonate: Timer = %TimerDetonate
@onready var flash_radius: Area3D = %FlashRadius


func start_detonation_timer() -> void:
	timer_detonate.start()


func _on_timer_detonate_timeout() -> void:
	flash_radius.monitoring = true
	await get_tree().create_timer(0.1).timeout
	flash_radius.monitoring = false


func _on_flash_radius_body_entered(body: Node3D) -> void:
	if body is Enemy or body is Player:
		bodies_in_range.push_back(body)
		print("peng!")
