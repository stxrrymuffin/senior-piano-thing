extends Node2D
@onready var line = $Line2D
@onready var hook_scene = preload("res://hook.tscn")
@onready var fish_scene = preload("res://fishing/fish.tscn")

var max_points = 250
var velocity = 700
var gravity = 250
var max_distance = 500

var CAN_ROD = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.visible = false
	for i in range(3):
		var new_fish = fish_scene.instantiate()
		add_child(new_fish)
	pass # Replace with function body.

func update_trajectory(delta):
	line.clear_points()
	var pos = $rod/Marker2D.global_position
	var vel = $rod/Marker2D.global_transform.x * velocity
	for i in max_points:
		line.add_point(pos)
		vel.y += gravity * delta
		pos += vel * delta
		if pos.y > max_distance:
			break
			
func _process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	if CAN_ROD:
		$rod.look_at(Vector2(max(300,mouse_position.x), min(350,max(100,mouse_position.y))))
		line.show()
		update_trajectory(delta)
	else:
		#print($rod/Marker2D.global_position, Vector2(get_node("rod").global_position.x,get_node("hook").global_position.y-0.5*get_node("hook").get_child("Sprite2D").get_height()))
		var cur_curve = draw_curved_line($rod/Marker2D.global_position, Vector2(get_node("hook").global_position.x,get_node("hook").global_position.y-5))
	if CAN_ROD and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		CAN_ROD = false
		toss_rod()
		
func draw_curved_line(start_point: Vector2, end_point: Vector2):
	var curve := Curve2D.new()
	var mid_point = start_point.lerp(end_point, 0.95)
	var control_offset = (end_point - start_point).normalized().rotated(PI / 2) * 50
	var start_out_tangent = (mid_point + control_offset) - start_point
	curve.add_point(start_point, Vector2.ZERO, start_out_tangent)
	curve.add_point(end_point)
	#curve.add_point(end_point, end_in_tangent, Vector2.ZERO)
	$Line2D2.points = curve.get_baked_points()
	return curve
		
func toss_rod():
	line.hide()
	var hook = hook_scene.instantiate()
	hook.z_index = -2
	add_child(hook)
	hook.transform = $rod/Marker2D.global_transform
	hook.velocity = hook.transform.x * velocity
	hook.gravity = gravity
	hook.max_distance = max_distance
	$Button.visible = true

func _on_button_pressed():
	CAN_ROD = true
	$Line2D.visible = true
	$Line2D2.clear_points()
	get_node("hook").queue_free()
	$Button.visible = false
