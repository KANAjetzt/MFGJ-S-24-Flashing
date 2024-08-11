extends LevelBase


@onready var game_times: Node3D = %GameTimes


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
	
	add_time(Global.time_game)


func add_time(time: int) -> void:
	var new_label := Label3D.new()
	new_label.text = Global.hud.format_stopwatch(time)
	new_label.font_size = 900
	new_label.translate(Vector3(0, 4 * game_times.get_child_count(), -(4 * game_times.get_child_count())))
	game_times.add_child(new_label)


func update_time(time: int) -> void:
	game_times.get_child(-1).text = Global.hud.format_stopwatch(time)


func activate_camera() -> void:
	super()
	Global.time_game = Global.time_engine


func _on_player_camera_tween_completed() -> void:
	if Global.current_arena_index == 0:
		%PortalNewGame.deactivated = true
		Global.time_game_start = Global.time_engine
		level_data.level_time = 0
