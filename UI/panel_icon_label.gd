@tool
class_name UIPanelIconLabel
extends PanelContainer


@export var label_text := "Example Text" :
	set(new_value):
		label_text =  new_value
		%Label.text = new_value
@export var icon_texture: Texture :
	set(new_value):
		icon_texture = new_value
		if new_value:
			%Icon.texture = new_value
			%Icon.custom_minimum_size = Vector2(30, 30)
		else:
			%Icon.texture = null
			%Icon.custom_minimum_size = Vector2(0, 0)
@export var icon_modulate: Color :
	set(new_value):
		icon_modulate = new_value
		if icon_texture:
			%Icon.modulate = new_value

@onready var label: Label = %Label
