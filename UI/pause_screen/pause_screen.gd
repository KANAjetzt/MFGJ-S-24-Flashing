extends PanelContainer


@onready var options_menu: UIOptionsMenu = $OptionsMenu


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not visible:
		toggle_pause()


func toggle_pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
		hide()
		if not Global.is_mouse_locked:
			Utils.toggle_mouse_lock()
	else:
		get_tree().paused = true
		show()
		options_menu.init()
		if Global.is_mouse_locked:
			Utils.toggle_mouse_lock()
		


func _on_options_menu_back_pressed() -> void:
	toggle_pause()
	
