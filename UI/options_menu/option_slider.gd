class_name UIOptionSlider
extends HBoxContainer


signal value_changed(value: float)

@export var title: String

@export_category("Slider")
@export var slider_min: float
@export var slider_max: float
@export var slider_step: float

@export_category("Spin Box")
@export var spin_box_min: float
@export var spin_box_max: float
@export var spin_box_step: float

@onready var label_title: Label = %Title
@onready var spin_box_value: SpinBox = %Value
@onready var slider: HSlider = %Slider
@onready var timer_set_value: Timer = %TimerSetValue


var is_initing := true
var is_dragging := false
var is_sliding := false
var is_sliding_left := false


func _ready() -> void:
	label_title.text = title

	slider.min_value = slider_min
	slider.max_value = slider_max
	slider.step = slider_step

	spin_box_value.min_value = spin_box_min
	spin_box_value.max_value = spin_box_max
	spin_box_value.step = spin_box_step

	# If the min_value is changed, the value is also changed
	# because the default value is set to 0.
	# This causes the value_changed signal to emit,
	# leading to the setting in SaveManager being overwritten.
	is_initing = false


func _process(delta: float) -> void:
	if slider.has_focus():
		if Input.is_action_pressed("ui_left"):
			is_sliding = true
			is_sliding_left = true
			if timer_set_value.is_stopped():
				timer_set_value.start()
		if Input.is_action_pressed("ui_right"):
			is_sliding = true
			is_sliding_left = false
			if timer_set_value.is_stopped():
				timer_set_value.start()

			is_sliding = false


func focus()  -> void:
	slider.grab_focus()


func set_value(value: float) -> void:
	slider.value = value


func _on_h_slider_value_changed(value: float) -> void:
	if is_initing:
		return

	value_changed.emit(value)

	if is_dragging:
		slider.step = slider_step

	spin_box_value.value = value


func _on_value_value_changed(value: float) -> void:
	if is_initing:
		return

	value_changed.emit(value)

	if not is_dragging:
		slider.step = 1.0

	slider.value = value


func _on_slider_drag_started() -> void:
	is_dragging = true


func _on_slider_drag_ended(value_changed: bool) -> void:
	is_dragging = false


func _on_timer_set_value_timeout() -> void:
	if not is_sliding:
		return

	if is_sliding_left:
		set_value(slider.value - 1)
	else:
		set_value(slider.value + 1)
