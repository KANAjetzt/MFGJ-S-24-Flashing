class_name UIOptionsVideo
extends VBoxContainer


@onready var option_full_screen = %OptionFullScreen


func init() -> void:
	option_full_screen.set_value(Global.settings.video_is_full_screen)
	show()


func focus() -> void:
	option_full_screen.focus()


func _on_options_check_button_value_changed(value: bool) -> void:
	Global.settings.video_is_full_screen = value

	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return

	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
