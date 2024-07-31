class_name LevelData
extends Resource

## Index in the Global Arena Array
@export var level_id: int
## Displayed name of the level
@export var level_name: String
@export var is_locked := false
@export var is_completed := false


## Global start position of the level, it is set by the StartPoint Node3D inside each level scene.
var start_position: Vector3
var enemy_count: int
var enemies_flashed_count: int

var enemies_flashed_count_best: int
