extends LevelBase


func _on_portal_hit_detected(destination: LevelData) -> void:
	Global.player.is_input_disabled = true
	Global.blend()
	await get_tree().create_timer(0.1).timeout
	Global.player.teleport(destination.start_transform)
	await get_tree().create_timer(0.1).timeout
	destination.ref.activate_camera()
