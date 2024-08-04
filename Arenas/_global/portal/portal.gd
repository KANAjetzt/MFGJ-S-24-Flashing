class_name Portal
extends StaticBody3D


signal hit_detected(destination: LevelData)

@export var destination: LevelData

@onready var hit_detector: Area3D = %HitDetector
@onready var label_level_name: Label3D = %LabelLevelName


func _ready() -> void:
	label_level_name.text = destination.level_name
	destination.level_completed.connect(_on_level_completed)


func _on_hit_detector_body_entered(body: Node3D) -> void:
	if not destination.is_locked:
		
		# Update the current arena index
		Global.current_arena_index = destination.level_id
		
		# Update flash limit
		if destination.flash_limit_active:
			Global.player.flash_count = destination.flash_limit
		else:
			Global.player.flash_count = -1
		
		Global.hud.panel_enemy_count.label_text = str(destination.enemy_count)
		
		# Reset the level timer
		Global.time_level_start = Global.time_game
		
		hit_detected.emit(destination)
	else:
		print("Sorry Destination is locked ❁´◡`❁)")

func _on_level_completed() -> void:
	label_level_name.text = "%s %s" % [label_level_name.text, "COMPLETE!"]
