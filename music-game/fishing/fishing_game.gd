extends Node2D
@onready var line = $Line2D
@onready var hook_scene = preload("res://fishing/hook.tscn")
@onready var fish_scene = preload("res://fishing/fish.tscn")
@onready var question_scene = preload("res://fishing/question_deck/q_interval_id.tscn")

var max_points = 250
var velocity = 700
var gravity = 250
var max_distance = 500

var CAN_ROD = false
var PICKED_POWER = false
var PICKED_DEPTH = false
var POWER = 0
var DEPTH = 0

var CUR_SCORE = 0
var CUR_FISH

var PAUSED = false
# errr this is breaking the game dont pause please :)

# Called when the node enters the scene tree for the first time.
func _ready():
	show_power()
	for i in range(3):
		var new_fish = fish_scene.instantiate()
		add_child(new_fish)
	$fade_in.visible = true
	$UI/refish.visible = false
	var tween = get_tree().create_tween()
	$Timer.wait_time = Globals.FISHING_TIME
	$Timer.start()
	await tween.tween_property($fade_in, "modulate:a", 0, 1).finished
	$fade_in.visible = false

func update_trajectory(delta):
	line.clear_points()
	var pos = $arm/rod/Marker2D.global_position
	var vel = $arm/rod/Marker2D.global_transform.x * velocity
	for i in max_points:
		line.add_point(pos)
		vel.y += gravity * delta
		pos += vel * delta
		if pos.y > max_distance:
			break
			
func _process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	if CAN_ROD or not PICKED_DEPTH:
		#$arm.look_at(Vector2(max(350,mouse_position.x), min(500,max(300,mouse_position.y))))
		$arm.rotation = lerp_angle(rotation, rotation + get_angle_to(Vector2(max(350,mouse_position.x),min(500,max(300,mouse_position.y)))), 0.5)
		$arm/rod.look_at(Vector2(max(350,mouse_position.x), min(500,max(300,mouse_position.y))))
	if CAN_ROD:
		line.show()
		update_trajectory(delta)
	elif PICKED_DEPTH:
		var cur_curve = draw_curved_line($arm/rod/Marker2D.global_position, Vector2(get_node("hook").global_position.x,get_node("hook").global_position.y-5))
	if not PICKED_POWER and Input.is_action_just_pressed("left_click"):
		PICKED_POWER = true
		velocity = 900 / (3 - sqrt(POWER))
		show_depth()
	elif not PICKED_DEPTH and Input.is_action_just_pressed("left_click"):
		PICKED_DEPTH = true
		CAN_ROD = true
		max_distance = 250 + (250 / (3 - sqrt(DEPTH)))
	elif CAN_ROD and Input.is_action_just_pressed("left_click"):
		CAN_ROD = false
		toss_rod()
		$AudioStreamPlayer3.play()
	$UI/Time.text = str(int($Timer.time_left))

func show_power():
	$PowerBar/AnimatedSprite2D.play("0")
	$UI/instruct.visible = true
	$UI/instruct.text = "[wave]Click to Set Power!"
	var increment = 1
	POWER = 0
	while PICKED_POWER == false:
		if not PAUSED:
			if POWER >= 5:
				increment = -1
			if POWER <= 0:
				increment = 1
			POWER += increment
			$PowerBar/AnimatedSprite2D.play(str(POWER))
			await get_tree().create_timer(0.25).timeout
	$AudioStreamPlayer2.play()
	return

func show_depth():
	$DepthBar/AnimatedSprite2D.play("0")
	$UI/instruct.text = "[wave]Click to Set Depth!"
	var increment = 1
	DEPTH = 0
	while PICKED_DEPTH == false:
		if not PAUSED:
			if DEPTH >= 5:
				increment = -1
			if DEPTH <= 0:
				increment = 1
			DEPTH += increment
			$DepthBar/AnimatedSprite2D.play(str(DEPTH))
			await get_tree().create_timer(0.25).timeout
	$AudioStreamPlayer2.play()
	return
		
func draw_curved_line(start_point: Vector2, end_point: Vector2):
	var curve := Curve2D.new()
	var mid_point = start_point.lerp(end_point, 0.95)
	var control_offset = (end_point - start_point).normalized().rotated(PI / 2) * 50
	var start_out_tangent = (mid_point + control_offset) - start_point
	curve.add_point(start_point, Vector2.ZERO, start_out_tangent)
	curve.add_point(end_point)
	$Line2D2.points = curve.get_baked_points()
	return curve
		
func toss_rod():
	line.hide()
	var hook = hook_scene.instantiate()
	hook.caught_fish.connect(add_question)
	hook.z_index = -2
	add_child(hook)
	hook.transform = $arm/rod/Marker2D.global_transform
	hook.velocity = hook.transform.x * velocity
	hook.gravity = gravity
	hook.max_distance = max_distance
	$UI/refish.visible = true
	$UI/instruct.visible = false

func _on_button_pressed():
	$AudioStreamPlayer2.play()
	CAN_ROD = false
	PICKED_POWER = false
	PICKED_DEPTH = false
	$DepthBar/AnimatedSprite2D.play("0")
	DEPTH = 0
	show_power()
	$Line2D.clear_points()
	$Line2D.visible = true
	$Line2D2.clear_points()
	get_node("hook").queue_free()
	$UI/refish.visible = false

func add_question(fish):
	print()
	$AudioStreamPlayer5.play()
	var new_q = question_scene.instantiate()
	new_q.position.x = 0
	new_q.position.y = 0
	new_q.z_index = 30
	add_child(new_q)
	new_q.selected_ans.connect(finished_question)
	CUR_FISH = fish
	
func finished_question(ans):
	if ans == 0:
		$AudioStreamPlayer4.play()
	else:
		$AudioStreamPlayer6.play()
	CUR_SCORE += ans*10
	$UI/Score.text = str(CUR_SCORE)
	print(CUR_FISH)
	if CUR_FISH:
		CUR_FISH.queue_free()
		_on_button_pressed()


func _on_timer_timeout():
	$Timer.stop()
	Globals.TOTAL_POINTS += CUR_SCORE
	$fade_out.visible = true
	var tween = get_tree().create_tween()
	await tween.tween_property($fade_out, "modulate:a", 1, 1).finished
	get_tree().change_scene_to_file("res://rewards_system/points_reward.tscn")


func _on_pause_pressed():
	get_tree().paused = !get_tree().paused
	PAUSED = !PAUSED
