class_name UIOptionsCheckButton
extends HBoxContainer


signal value_changed(value: bool)

@export var title: String


@onready var label_title: Label = %Title
@onready var check_button: CheckButton = %CheckButton


func _ready() -> void:
	label_title.text = title


func focus() -> void:
	check_button.grab_focus()


func set_value(value: bool) -> void:
	check_button.button_pressed = value


func _on_check_button_toggled(toggled_on: bool) -> void:
	value_changed.emit(toggled_on)
