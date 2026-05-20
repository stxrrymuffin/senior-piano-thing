extends Node2D

var arrow = load("res://assets/mouse.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	update_points()
	DialogueManager.show_dialogue_balloon(load("res://rewards_system/dialogue/shop.dialogue"), "start")

func update_points():
	var tween = create_tween()
	tween.tween_method(_set_points_text, Globals.OLD_POINTS, Globals.TOTAL_POINTS, 3.0)
	Globals.OLD_POINTS = Globals.TOTAL_POINTS
	
func _set_points_text(value: int):
	if $Score.text != str(value):
		$AudioStreamPlayer3.play()
	$Score.text = str(value)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
