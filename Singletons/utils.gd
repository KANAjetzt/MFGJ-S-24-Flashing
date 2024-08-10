extends Node


func toggle_mouse_lock() -> void:
	if Global.is_mouse_locked:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.is_mouse_locked = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.is_mouse_locked = true


func free_all_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()


## Used to tween shader uniforms
func tween_shader_prop(value: float, material: ShaderMaterial, prop_name: String) -> void:
	material.set_shader_parameter(prop_name, value)
