extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$fade_in.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_in, "modulate:a", 0, 1).finished
	$fade_in.visible = false

func _on_refish_pressed():
	$AudioStreamPlayer2.play()
	$fade_out.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	get_tree().change_scene_to_file("res://scenes/Test.tscn")


func _on_return_pressed():
	$AudioStreamPlayer2.play()
	$fade_out.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	get_tree().change_scene_to_file("res://rewards_system/points_reward.tscn")
