class_name UIOptionsGameplay
extends VBoxContainer


@onready var crosshair_color: ColorPickerButton = %CrosshairColor


# Called when the node enters the scene tree for the first time.
func init() -> void:
	crosshair_color.color = Global.settings.gameplay_crosshair_color
	show()

func focus() -> void:
	crosshair_color.grab_focus()

func _on_crosshair_color_color_changed(color: Color) -> void:
	Global.settings.gameplay_crosshair_color = color
	Global.settings.crosshair_color_changed.emit(color)
