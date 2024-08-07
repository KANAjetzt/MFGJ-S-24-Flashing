class_name UIHUD
extends CanvasLayer


@onready var panel_flash_count: UIPanelIconLabel = %PanelFlashCount
@onready var panel_enemy_count: UIPanelIconLabel = %PanelEnemyCount
@onready var panel_time_level: UIPanelIconLabel = %PanelTimeLevel
@onready var panel_time_game: UIPanelIconLabel = %PanelTimeGame
@onready var panel_score: UIPanelIconLabel = %PanelScore
@onready var score_display: UIScoreDisplay = %ScoreDisplay

@onready var crosshair: TextureRect = %Crosshair
@onready var skip: HBoxContainer = %Skip


func _ready() -> void:
	Global.settings.crosshair_color_changed.connect(_on_crosshair_color_changed)
	Global.settings.show_overall_timer_changed.connect(_on_gameplay_ui_show_overall_timer)
	Global.settings.show_level_timer_changed.connect(_on_gameplay_ui_show_level_timer)
	
	crosshair.modulate = Global.settings.gameplay_crosshair_color
	panel_time_game.visible = Global.settings.gameplay_ui_show_overall_timer
	panel_time_level.visible = Global.settings.gameplay_ui_show_level_timer
	panel_score.label_text = ""


func format_stopwatch(elapsed_time: int) -> String:
	var total_seconds = elapsed_time / 1000
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	var milliseconds = elapsed_time % 1000
	var ms = milliseconds / 10  # Get the first two digits of the milliseconds

	return "%02d:%02d:%02d" % [minutes, seconds, ms]


func format_score(score: int) -> String:
	var str_number = str(score)
	var formatted_number = ""
	var count = 0
	
	for i in range(str_number.length() - 1, -1, -1):
		formatted_number = str_number[i] + formatted_number
		count += 1
		if count == 3 and i != 0:
			formatted_number = "." + formatted_number
			count = 0

	return formatted_number


func skip_display_fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(skip, "modulate:a", 1.0, 0.2)


func skip_display_fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(skip, "modulate:a", 0.0, 0.2)


func _on_crosshair_color_changed(new_color: Color) -> void:
	crosshair.modulate = new_color


func _on_gameplay_ui_show_overall_timer(new_value: bool) -> void:
	if new_value:
		panel_time_game.show()
	else:
		panel_time_game.hide()


func _on_gameplay_ui_show_level_timer(new_value: bool) -> void:
	if new_value:
		panel_time_level.show()
	else:
		panel_time_level.hide()
