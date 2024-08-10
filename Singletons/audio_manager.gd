class_name AudioManager
extends Node


var ambiences_variable: Array[AudioStreamPlayer]
var ambiences_fixed: Array[AudioStreamPlayer]
var ambiences_fixed_dbs: Array[float] = []

@onready var timer_change_ambience: Timer = %TimerChangeAmbience
@onready var timer_change_ambience_fixed: Timer = %TimerChangeAmbienceFixed
@onready var ambiences_variable_node: Node = %Ambience/Variable
@onready var ambiences_fixed_node: Node = %Ambience/Fixed
@onready var sfx: Node = %SFX


func _ready() -> void:
	ambiences_variable.assign(ambiences_variable_node.get_children())
	ambiences_fixed.assign(ambiences_fixed_node.get_children())
	
	for ambience in ambiences_fixed:
		ambiences_fixed_dbs.push_back(ambience.volume_db)


func play_global_sfx(audio: AudioStream, db: float = 0.0, delay := 0.0, pitch_scale: float = randf_range(0.85, 1.2)) -> void:
	await get_tree().create_timer(delay).timeout
	var new_audio_steam := AudioStreamPlayer.new()
	sfx.add_child(new_audio_steam)
	
	new_audio_steam.pitch_scale = pitch_scale
	new_audio_steam.volume_db = db
	new_audio_steam.stream = audio
	new_audio_steam.bus = &"SoundFX"
	
	new_audio_steam.play()
	
	await new_audio_steam.finished
	await get_tree().create_timer(1.0)
	new_audio_steam.queue_free()


func fade_in(ambience: AudioStreamPlayer, duration := 5.0) -> void:
	ambience.play()
	var tween := create_tween()
	tween.tween_property(ambience, "volume_db", -2.0, duration)
	

func fade_out(ambience: AudioStreamPlayer, duration := 5.0) -> void:
	var tween := create_tween()
	tween.tween_property(ambience, "volume_db", -10.0, duration)
	await tween.finished
	ambience.stop()


func _on_timer_change_ambience_timeout() -> void:
	var random_ambience: AudioStreamPlayer = ambiences_variable.pick_random()
	if random_ambience.playing:
		fade_out(random_ambience)
		print("fade_out")
	else:
		random_ambience.pitch_scale = randf_range(0.9, 1.1)
		fade_in(random_ambience)
		print("fade_in")
	
	timer_change_ambience.start(randf_range(5.0, 10.0))
	


func _on_timer_change_ambience_fixed_timeout() -> void:
	var random_ambience_i = randi_range(0, ambiences_fixed.size() - 1)
	var random_ambience: AudioStreamPlayer = ambiences_fixed[random_ambience_i]
	var tween := create_tween()
	tween.tween_property(random_ambience, "pitch_scale", randf_range(0.95, 1.05), 5.0)
	if random_ambience.volume_db == ambiences_fixed_dbs[random_ambience_i]:
		tween.parallel().tween_property(random_ambience, "volume_db", randf_range(-6.0, 1.0), 5.0)
	else:
		tween.parallel().tween_property(random_ambience, "volume_db", ambiences_fixed_dbs[random_ambience_i], 5.0)
	
	timer_change_ambience_fixed.start(randf_range(5.0, 10.0))
