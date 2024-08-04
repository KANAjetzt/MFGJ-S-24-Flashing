class_name UIOptionsAudio
extends VBoxContainer


@onready var audio_main: UIOptionSlider = %AudioMain
@onready var audio_music: UIOptionSlider = %AudioMusic
@onready var audio_sound: UIOptionSlider = %AudioSound


func init() -> void:
	audio_main.set_value(Global.settings.sound_main * 100)
	audio_music.set_value(Global.settings.sound_music * 100)
	audio_sound.set_value(Global.settings.sound_sfx * 100)
	show()


func focus() -> void:
	audio_main.focus()


func _on_audio_main_value_changed(value: float) -> void:
	Global.settings.sound_main = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Master"), linear_to_db(value / 100))


func _on_audio_music_value_changed(value: float) -> void:
	Global.settings.sound_music = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), linear_to_db(value / 100))


func _on_audio_sound_value_changed(value: float) -> void:
	Global.settings.sound_sfx = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"SoundFX"), linear_to_db(value / 100))
