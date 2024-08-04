extends LevelBase


func _on_portal_hit_detected(destionation: LevelData) -> void:
	Global.blend()
	await get_tree().create_timer(0.1).timeout
	if destionation.flash_limit_active:
		Global.player.flash_count = destionation.flash_limit
	else:
		Global.player.flash_count = -1
	Global.player.teleport(destionation.start_transform)
	await get_tree().create_timer(0.1).timeout
	destionation.ref.activate_camera()
