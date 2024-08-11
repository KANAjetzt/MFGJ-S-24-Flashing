class_name LevelData
extends Resource

signal level_completed


## True if currently the active level
@export var is_active := false :
	set(new_value):
		is_active = new_value
		if ref and not level_id == 0:
			if new_value == true:
				Global.level_container.add_child(ref)
			else:
				Global.level_container.remove_child.call_deferred(ref)

## Index in the Global Arena Array
@export var level_id: int
## Displayed name of the level
@export var level_name: String
## True if the level has the unlocked by something
@export var is_locked := false
## Current completion state of the level
@export var is_completed := false :
	set(new_value):
		is_completed = new_value
		if is_completed:
			has_been_completed = true
			handle_unlocks()
			level_times.push_back(level_current_time)
			print("LevelData: Level Completed!")
			Global.audio_manager.play_global_sfx(level_complete_sfx, 18.0, 0.3)
			Global.activate_gltich()
			Global.level_completed_count = Global.level_completed_count + 1
			
			if flashes_used <= 1:
				score_flashes_bonus = Global.score_data.flashes_bonus
			
			if level_current_time < level_time_best:
				level_time_best = level_current_time
			
			score_time_calc()
			
			add_to_score(score_flashes_used + score_flashes_bonus)
			if score_flashes_bonus:
				Global.hud.score_display.add_to_stack(score_flashes_used, "%s flash devices used" % flashes_used, score_flashes_bonus, "only one flash used!")
			else:
				Global.hud.score_display.add_to_stack(score_flashes_used, "%s flash devices used" % flashes_used)
			
			level_completed.emit()

## True if the level has been completed in the past TODO: Add save system ?!
@export var has_been_completed := false
## List of levels that are unlocked by completing this one
@export var unlocks: Array[LevelData] = []
## Amount of flashes allowed in this level
@export var flash_limit := 5
@export var flash_limit_active := true
## The base level time in seconds, used for points
## Base Time / 500 Points
## 10 Points for each second unter that
## -10 Points for each second above that
@export var level_time: int
@export var level_complete_sfx: AudioStream = preload("res://sounds/SFX/finish_0.ogg")

## Reference of the instanced level
var ref: LevelBase
## Global start transform of the level, it is set by the StartPoint Node3D inside each level scene.
var start_transform: Transform3D
## The Transform of the level on the main scene.
## Get's stored here in main ready.
var main_transform: Transform3D
## Is generated by the child count of the levels Enemies Node
var enemy_count: int
## The current count of flashed enemies
var enemies_flashed_count: int :
	set(new_value):
		enemies_flashed_count = new_value

		Global.hud.panel_enemy_count.label_text = str(enemy_count - new_value)

		if enemies_flashed_count >= enemy_count:
			await Global.get_tree().create_timer(0.5).timeout
			is_completed = true

		if enemies_flashed_count > enemies_flashed_count_best:
			enemies_flashed_count_best = enemies_flashed_count

## The "high score" of the level
var enemies_flashed_count_best: int = 0

## The amount flashes used to complete the level
var flashes_used: int = 0 :
	set(new_value):
		flashes_used = new_value
		if flashes_used > 1:
			score_flashes_used = Global.score_data.flashes - ((flashes_used - 1) * score_per_flash)
		else:
			score_flashes_used = Global.score_data.flashes

## Current time spend on this level in ms
var level_current_time: int = 0 :
	set(new_value):
		level_current_time = new_value
		if level_current_time % 500:
			if level_current_time < level_time * 1000:
				score_time_bonus = Global.score_data.time_bonus * (level_time - level_current_time / 1000)
				score_time = Global.score_data.time + score_time_bonus
			else:
				score_time_reduction = Global.score_data.time_reduction * (level_current_time / 1000 - level_time)
				score_time = Global.score_data.time - score_time_reduction
		
## Best time on this level
var level_time_best: int = INF
var level_times: Array[int]

## Combined score of the level
var level_score: int = 0 :
	set(new_value):
		level_score = new_value
		if level_score > level_score_best:
			level_score_best = level_score
## Best combined score of this level
var level_score_best: int = 0

# flash score max / flash_limit - 1
var score_per_flash: int = 0
## flash score max - score_per_flash * flashes used
var score_flashes_used: int = 0
## Bonus Points for one flash used
var score_flashes_bonus: int = 0 :
	set(new_value):
		score_flashes_bonus = new_value
		score_flashes_used = score_flashes_used + score_flashes_bonus

## 100 Points for each Enemy flashed
var score_enemy: int = 0
## Combo Bonus +50 Points for each multiple
var score_enemy_bonus: int = 0

## Base Time / 500 Points
var score_time: int = 0
## +10 Points for each second unter level_time
var score_time_bonus: int = 0
## -10 Points for each second above level_time
var score_time_reduction: int = 0


func handle_unlocks() -> void:
	for unlock in unlocks:
		unlock.is_locked = false


func score_add_enemy(enemy_count: int) -> void:
	if enemy_count > 1:
		var current_bonus = (enemy_count - 1) * Global.score_data.enemies_bonus
		score_enemy += Global.score_data.enemies * enemy_count
		score_enemy_bonus += current_bonus
		add_to_score(Global.score_data.enemies * enemy_count)
		add_to_score(current_bonus)
		Global.hud.score_display.add_to_stack(Global.score_data.enemies * enemy_count, "%s enemies flashed" % enemy_count, current_bonus, "at once")
	else:
		score_enemy += Global.score_data.enemies
		add_to_score(Global.score_data.enemies)
		Global.hud.score_display.add_to_stack(Global.score_data.enemies, "one enemy flashed")


func score_time_calc() -> void:
	if level_current_time < level_time * 1000:
		score_time_bonus = Global.score_data.time_bonus * (level_time - level_current_time / 1000)
		score_time = Global.score_data.time + score_time_bonus
		Global.hud.score_display.add_to_stack(score_time - score_time_bonus, "beat level time %s" % Global.hud.format_stopwatch(level_current_time), score_time_bonus, "by %s" % Global.hud.format_stopwatch((level_time - level_current_time / 1000)))
	else:
		score_time_reduction = Global.score_data.time_reduction * (level_current_time / 1000 - level_time)
		score_time = max(0, Global.score_data.time - score_time_reduction)

	add_to_score(score_time)


func add_to_score(value: int) -> void:
	Global.score += value
	level_score += value


func score_get_all() -> int:
	return score_flashes_used + score_enemy + score_time


func reset() -> void:
	enemies_flashed_count = 0
	flashes_used = 0
	is_locked = false
	is_completed = false
	level_current_time = 0
	level_score = 0
	score_enemy = 0
	score_enemy_bonus = 0
	score_flashes_bonus = 0
	score_flashes_used = 0
	score_per_flash = 0
	level_time = 0
	score_time = 0
	score_time_bonus = 0
	score_time_reduction = 0
	ref.queue_free()
