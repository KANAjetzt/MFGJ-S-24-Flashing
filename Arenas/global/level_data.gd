class_name LevelData
extends Resource

## Id used to identify the level
@export var level_id: StringName
## Displayed name of the level
@export var level_name: String
@export var is_locked := false


## Global start position of the level, it is set by the StartPoint Node3D inside each level scene.
var start_position: Vector3
