@tool
class_name PropWallPlayArea
extends PropWall


var circle_distances_from_center: Array[float]
var circle_directions_from_center: Array[Vector2]

@onready var material_shield: ShaderMaterial = %MeshInstance3D.get_active_material(0)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if Global.flash_container.get_child_count() > 0:
		material_shield.set_shader_parameter("_flash_global_position", Global.flash_container.get_child(-1).global_position)
