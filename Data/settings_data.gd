class_name SettingsData
extends Resource


signal crosshair_color_changed(color)

@export var gameplay_crosshair_color: Color : 
	set(new_value):
		gameplay_crosshair_color = new_value
		crosshair_color_changed.emit(new_value)
	
@export var sound_main: float = 0.5
@export var sound_music: float = 0.2
@export var sound_sfx: float = 1.0

@export var video_is_fps_limit_active := true
@export var video_fps_limit := 350
@export var video_is_full_screen := false
