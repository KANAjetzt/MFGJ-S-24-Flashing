class_name Portal
extends StaticBody3D


signal flash_hit_detected(destination_position: Vector3)

@export var destination: LevelData

@onready var flash_hit_detector: Area3D = %FlashHitDetector
@onready var label_level_name: Label3D = %LabelLevelName


func _ready() -> void:
	label_level_name.text = destination.level_name


func _on_flash_hit_detector_body_entered(body: Node3D) -> void:
	Global.current_arena_index = destination.level_id
	flash_hit_detected.emit(destination.start_position)
