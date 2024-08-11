extends Portal


@export var label_level_name_override := "New Game"


func _ready() -> void:
	super()
	label_level_name.text = label_level_name_override


func _on_hit_detector_body_entered(body: Node3D) -> void:
	super(body)
	Global.reset_game()
