extends Node2D
@onready var line = $Line2D
var max_points = 250
var muzzle_velocity = 700
var gravity = 250

var CAN_ROD = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_trajectory(delta):
	line.clear_points()
	var pos = $Sprite2D/Marker2D.global_position
	var vel = $Sprite2D/Marker2D.global_transform.x * muzzle_velocity
	for i in max_points:
		line.add_point(pos)
		vel.y += gravity * delta
		pos += vel * delta
		if pos.y > 500:
			break
			
func _process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	if CAN_ROD:
		$Sprite2D.look_at(Vector2(max(300,mouse_position.x), min(350,max(100,mouse_position.y))))
		line.show()
		update_trajectory(delta)
		
func _on_Bullet_exploded(pos):
	line.hide()
