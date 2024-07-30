extends LevelBase


func _on_portal_3_flash_hit_detected(level_start_position: Vector3) -> void:
	Global.player.teleport(level_start_position)
