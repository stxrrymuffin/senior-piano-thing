extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$circle.rotate(0.5 * delta)


func _on_return_pressed():
	get_tree().change_scene_to_file("res://rewards_system/points_reward.tscn")
