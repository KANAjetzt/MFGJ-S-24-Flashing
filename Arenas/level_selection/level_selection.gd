extends LevelBase


func _on_portal_3_flash_hit_detected(level_start_transform: Transform3D) -> void:
	Global.player.teleport(level_start_transform)
