class_name UIOptionsMenu
extends PanelContainer

signal back_pressed

@onready var sound_settings: UIOptionsAudio = %SettingsAudio
@onready var video_settings: UIOptionsVideo = %OptionsVideo
@onready var options_gameplay: UIOptionsGameplay = %OptionsGameplay
@onready var settings: MarginContainer = %Settings
@onready var button_category_sound: Button = %ButtonCategorySound
@onready var button_category_video: Button = %ButtonCategoryVideo
@onready var button_category_gameplay: Button = %ButtonCategoryGameplay
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var current_category_button := button_category_sound

var is_in_category_selection := true


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_in_category_selection and visible:
		back()
	if event.is_action_pressed("ui_cancel") and not is_in_category_selection:
		current_category_button.grab_focus()
		is_in_category_selection = true


func init() -> void:
	hide_all_children(settings)
	animation_player.play("fade_in")
	sound_settings.init()
	is_in_category_selection = true


func back() -> void:
	animation_player.play("fade_in", -1, -1.0, true)
	await animation_player.animation_finished
	back_pressed.emit()
	is_in_category_selection = true


func hide_all_children(parent_node: Node) -> void:
	for child in parent_node.get_children():
		child.hide()


func _on_button_category_sound_pressed() -> void:
	hide_all_children(settings)
	sound_settings.init()
	sound_settings.focus()
	current_category_button = button_category_sound
	is_in_category_selection = false


func _on_button_category_video_pressed() -> void:
	hide_all_children(settings)
	video_settings.init()
	video_settings.focus()
	current_category_button = button_category_video
	is_in_category_selection = false


func _on_button_category_gameplay_pressed() -> void:
	hide_all_children(settings)
	options_gameplay.init()
	options_gameplay.focus()
	current_category_button = button_category_gameplay


func _on_button_back_pressed() -> void:
	back()
