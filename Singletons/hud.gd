class_name UIHUD
extends CanvasLayer


@onready var panel_flash_count: UIPanelIconLabel = %PanelFlashCount
@onready var panel_enemy_count: UIPanelIconLabel = %PanelEnemyCount
@onready var panel_time_level: UIPanelIconLabel = %PanelTimeLevel
@onready var panel_time_game: UIPanelIconLabel = %PanelTimeGame

@onready var crosshair: TextureRect = %Crosshair
@onready var skip: HBoxContainer = %Skip


func _ready() -> void:
	Global.settings.crosshair_color_changed.connect(_on_crosshair_color_changed)
	crosshair.modulate = Global.settings.gameplay_crosshair_color


func format_stopwatch(elapsed_time: int) -> String:
	var total_seconds = elapsed_time / 1000
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	var milliseconds = elapsed_time % 1000
	var ms = milliseconds / 10  # Get the first two digits of the milliseconds

	return "%02d:%02d:%02d" % [minutes, seconds, ms]


func skip_display_fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(skip, "modulate:a", 1.0, 0.2)


func skip_display_fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(skip, "modulate:a", 0.0, 0.2)


func _on_crosshair_color_changed(new_color: Color) -> void:
	crosshair.modulate = new_color
