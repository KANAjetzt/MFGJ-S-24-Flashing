class_name SettingsData
extends Resource


signal crosshair_color_changed(color)

@export var crosshair_color: Color : 
	set(new_value):
		crosshair_color = new_value
		crosshair_color_changed.emit(new_value)
	
