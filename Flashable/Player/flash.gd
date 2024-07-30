class_name Flash
extends RigidBody3D

signal flashed(flash: Flash, bodies_in_range: Array[Flashable])

var bodies_in_range: Array[Flashable] = []

@onready var timer_detonate: Timer = %TimerDetonate
@onready var flash_radius: Area3D = %FlashRadius


func start_detonation_timer() -> void:
	timer_detonate.start()


func _on_timer_detonate_timeout() -> void:
	flash_radius.monitoring = true
	var overlap := flash_radius.get_overlapping_bodies()
	await get_tree().create_timer(0.1).timeout
	flash_radius.monitoring = false
	flashed.emit(self, bodies_in_range)
	flash_radius.hide()


func _on_flash_radius_body_entered(body: Node3D) -> void:
	if body is Flashable:
		bodies_in_range.push_back(body)
		print("peng!")
		print(bodies_in_range.size())
