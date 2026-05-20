extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$HSlider.value = Globals.FISHING_TIME
	$HSlider2.value = Globals.FISHING_MCQ_TIME
	$fade_in.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_in, "modulate:a", 0, 1).finished
	$fade_in.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_h_slider_value_changed(value):
	$RichTextLabel2.text = "Minigame Length: " + str(int(value)) + " sec"
	Globals.FISHING_TIME = value


func _on_h_slider_2_value_changed(value):
	$RichTextLabel.text = "Question Length: " + str(int(value)) + " sec"
	Globals.FISHING_MCQ_TIME = value


func _on_refish_pressed():
	$AudioStreamPlayer2.play()
	$fade_out.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	get_tree().change_scene_to_file("res://fishing/fishing_game.tscn")


func _on_return_pressed():
	$AudioStreamPlayer2.play()
	$fade_out.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	get_tree().change_scene_to_file("res://rewards_system/points_reward.tscn")
