extends LevelBase


func _ready() -> void:
	super()
	Global.current_arena_index = level_data.level_id
	
	Global.game_won.connect(_on_game_won)
	Global.player.camera.tween_completed.connect(_on_player_camera_tween_completed)


func _on_portal_hit_detected(destination: LevelData) -> void:
	Global.player.is_input_disabled = true
	Global.blend()
	await get_tree().create_timer(0.1).timeout
	Global.player.teleport(destination.start_transform)
	Global.player.activate_particles()
	await get_tree().create_timer(0.1).timeout
	destination.ref.activate_camera()


func _on_game_won(first: bool) -> void:
	%PortalNewGame.deactivated = false
	if first and not Global.settings.gameplay_ui_show_level_timer:
		Global.settings.gameplay_ui_show_level_timer = true
	if first and not Global.settings.gameplay_ui_show_overall_timer:
		Global.settings.gameplay_ui_show_overall_timer = true


func activate_camera() -> void:
	super()
	Global.time_game = Global.time_engine


func _on_player_camera_tween_completed() -> void:
	if Global.current_arena_index == 0:
		%PortalNewGame.deactivated = true
		Global.time_game_start = Global.time_engine
		level_data.level_time = 0
