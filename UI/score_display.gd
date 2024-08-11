class_name UIScoreDisplay
extends Control


func _ready() -> void:
	$VBoxContainer/HBoxContainer.queue_free()


func add_to_stack(score:int, score_text: String, score_bonus: int = 0, score_bonus_text: String = "") -> void:
	print("%s " % score_text,  "%s " % score,"%s " % score_bonus,"%s " % (score + score_bonus))
	var h_box := HBoxContainer.new()
	h_box.alignment = BoxContainer.ALIGNMENT_CENTER
	var label_score := Label.new()
	label_score.text = score_text
	label_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	var label_score_bonus := Label.new()
	label_score_bonus.text = score_bonus_text
	label_score_bonus.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if score_bonus == 0:
		label_score_bonus.modulate.a = 0
	
	%VBoxContainer.add_child(h_box)
	h_box.add_child(label_score)
	h_box.add_child(label_score_bonus)
	
	var tween := create_tween()
	tween.tween_property(label_score_bonus, "text", str(score_bonus), 0.2).set_delay(3.0)
	tween.parallel().tween_property(label_score, "text", str(score), 0.2).set_delay(3.0)
	tween.tween_property(label_score, "text", str(score + score_bonus), 0.5).set_delay(1.5)
	tween.parallel().tween_property(label_score_bonus, "modulate:a", 0.0, 0.2).set_delay(1.5)
	tween.tween_property(label_score, "global_position", Global.hud.panel_score.label.global_position, 1.0).set_delay(1.0)
	tween.parallel().tween_property(label_score, "modulate:a", 0.0, 1.0).set_delay(0.7)
	await tween.finished
	
	h_box.queue_free()
