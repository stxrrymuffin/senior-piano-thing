extends Node2D

var arrow = load("res://assets/mouse.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	$fade_in.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_in, "modulate:a", 0, 1).finished
	$fade_in.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	#$fade_out.visible = true
	#var tween = get_tree().create_tween()
	#await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	#get_tree().change_scene_to_file("res://rewards_system/points_reward.tscn")


func _on_play_mouse_entered():
	$"3".set("theme_override_colors/default_color", Color.WHITE) 
	$credits.set("theme_override_colors/default_color", Color.WHITE) 
	$"2".set("theme_override_colors/default_color", Color.WHITE) 
	$settings.set("theme_override_colors/default_color", Color.WHITE) 
	
	$bar.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($bar, "position", Vector2(38,355), 0.2).set_ease(Tween.EASE_OUT).finished
	$"1".set("theme_override_colors/default_color", Color(0.23, 0.47, 0.15)) 
	$play.set("theme_override_colors/default_color", Color(0.23, 0.47, 0.15)) 
	$"3".set("theme_override_colors/default_color", Color.WHITE) 
	$credits.set("theme_override_colors/default_color", Color.WHITE) 
	$"2".set("theme_override_colors/default_color", Color.WHITE) 
	$settings.set("theme_override_colors/default_color", Color.WHITE) 
	$AudioStreamPlayer2.play()
	

func _on_settings_mouse_entered():
	$"1".set("theme_override_colors/default_color", Color.WHITE) 
	$play.set("theme_override_colors/default_color", Color.WHITE) 
	$"3".set("theme_override_colors/default_color", Color.WHITE) 
	$credits.set("theme_override_colors/default_color", Color.WHITE) 
	
	$bar.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($bar, "position", Vector2(11,444), 0.2).set_ease(Tween.EASE_OUT).finished
	$"2".set("theme_override_colors/default_color", Color(0.23, 0.47, 0.15)) 
	$settings.set("theme_override_colors/default_color", Color(0.23, 0.47, 0.15)) 
	$"1".set("theme_override_colors/default_color", Color.WHITE) 
	$play.set("theme_override_colors/default_color", Color.WHITE) 
	$"3".set("theme_override_colors/default_color", Color.WHITE) 
	$credits.set("theme_override_colors/default_color", Color.WHITE) 
	$AudioStreamPlayer2.play()

func _on_credits_mouse_entered():
	$"1".set("theme_override_colors/default_color", Color.WHITE) 
	$play.set("theme_override_colors/default_color", Color.WHITE) 
	$"2".set("theme_override_colors/default_color", Color.WHITE) 
	$settings.set("theme_override_colors/default_color", Color.WHITE) 
	
	$bar.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($bar, "position", Vector2(-16,533), 0.2).set_ease(Tween.EASE_OUT).finished
	$"3".set("theme_override_colors/default_color", Color(0.23, 0.47, 0.15)) 
	$credits.set("theme_override_colors/default_color", Color(0.23, 0.47, 0.15)) 
	$"1".set("theme_override_colors/default_color", Color.WHITE) 
	$play.set("theme_override_colors/default_color", Color.WHITE) 
	$"2".set("theme_override_colors/default_color", Color.WHITE) 
	$settings.set("theme_override_colors/default_color", Color.WHITE) 
	$AudioStreamPlayer2.play()
	

func fade_out():
	$fade_out.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	get_tree().change_scene_to_file("res://rewards_system/points_reward.tscn")


func _on_play_gui_input(event):
	if event is InputEventMouseButton:
		print("mouse button")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$AudioStreamPlayer3.play()
			fade_out()
