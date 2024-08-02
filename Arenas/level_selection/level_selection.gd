extends LevelBase


func _on_portal_3_flash_hit_detected(destionation: LevelData) -> void:
	Global.blend()
	await get_tree().create_timer(0.1).timeout
	Global.player.teleport(destionation.start_transform)
	await get_tree().create_timer(0.1).timeout
	destionation.ref.activate_camera()
