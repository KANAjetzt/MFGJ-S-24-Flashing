class_name Portal
extends StaticBody3D


signal hit_detected(destination: LevelData)

@export var destination: LevelData
@export var port_sound: AudioStream
@export var deactivated := false :
	set(new_value):
		deactivated = new_value
		if get_node_or_null("%GPUParticles3D") and get_node_or_null("%CollisionShape3D"):
			if deactivated:
				%GPUParticles3D.emitting = false
				%CollisionShape3D.disabled = true
				%HitDetector.monitoring = false
				hide()
			else:
				%GPUParticles3D.emitting = true
				%CollisionShape3D.disabled = false
				%HitDetector.monitoring = true
				show()

@onready var hit_detector: Area3D = %HitDetector
@onready var label_level_name: Label3D = %LabelLevelName
@onready var sfx_porting: AudioStreamPlayer3D = %SFXPorting
@onready var gpu_particles_3d: GPUParticles3D = %GPUParticles3D
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var times: Node3D = %Times


func _ready() -> void:
	label_level_name.text = destination.level_name
	destination.level_completed.connect(_on_level_completed)
	
	if deactivated:
		gpu_particles_3d.emitting = false
		collision_shape_3d.disabled = true
		hide()


func add_time(time: int) -> void:
	var new_label := Label3D.new()
	new_label.text = Global.hud.format_stopwatch(time)
	new_label.translate(Vector3(0, 0.25 * times.get_child_count(), 0))
	times.add_child(new_label)


func _on_hit_detector_body_entered(body: Node3D) -> void:
	if not destination.is_locked:
		
		Global.audio_manager.play_global_sfx(port_sound, 0.0)
		
		# Update the current arena index
		Global.current_arena_index = destination.level_id
		
		# Free all curren flashes
		Utils.free_all_children(Global.flash_container)
		
		# Update flash limit
		if destination.flash_limit_active:
			Global.player.flash_count = destination.flash_limit
			destination.score_per_flash = Global.score_data.flashes / (destination.flash_limit)
		else:
			Global.player.flash_count = -1
			destination.score_per_flash = 0
		
		Global.hud.panel_enemy_count.label_text = str(destination.enemy_count)
		
		# Reset the level timer
		Global.time_level_start = Global.time_game
		
		hit_detected.emit(destination)
	else:
		print("Sorry Destination is locked ❁´◡`❁)")

func _on_level_completed() -> void:
	label_level_name.text = "%s %s" % [label_level_name.text, "COMPLETE!"]
	add_time(destination.level_times[-1])
