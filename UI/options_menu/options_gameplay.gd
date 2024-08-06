class_name UIOptionsGameplay
extends VBoxContainer


@onready var crosshair_color: ColorPickerButton = %CrosshairColor
@onready var options_show_game_timer: UIOptionsCheckButton = %OptionsShowGameTimer
@onready var options_show_level_timer: UIOptionsCheckButton = %OptionsShowLevelTimer


# Called when the node enters the scene tree for the first time.
func init() -> void:
	crosshair_color.color = Global.settings.gameplay_crosshair_color
	options_show_game_timer.set_value(Global.settings.gameplay_ui_show_overall_timer)
	options_show_level_timer.set_value(Global.settings.gameplay_ui_show_level_timer)
	show()

func focus() -> void:
	crosshair_color.grab_focus()

func _on_crosshair_color_color_changed(color: Color) -> void:
	Global.settings.gameplay_crosshair_color = color
	Global.settings.crosshair_color_changed.emit(color)


func _on_options_show_game_timer_value_changed(value: bool) -> void:
	Global.settings.gameplay_ui_show_overall_timer = value
	Global.settings.show_overall_timer_changed.emit(value)


func _on_options_show_level_timer_value_changed(value: bool) -> void:
	Global.settings.gameplay_ui_show_level_timer = value
	Global.settings.show_level_timer_changed.emit(value)
