extends Area2D

var MIN_Y = 350
var MAX_Y = 650
var MIN_X = 300
var MAX_X = 1100
var velocity = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index=-5
	MIN_X = randf_range(MIN_X, MAX_X)
	MAX_X = randf_range(MIN_X, MAX_X)
	while abs(MIN_X-MAX_X) < 100:
		MIN_X = 100
		MAX_X = 1100
		MIN_X = randf_range(MIN_X, MAX_X)
		MAX_X = randf_range(MIN_X, MAX_X)
	position.x = randf_range(MIN_X, MAX_X)
	position.y = randf_range(MIN_Y, MAX_Y)
	velocity = randf_range(0.1,1)

func distressed():
	var old_velocity = velocity
	velocity = 2
	await get_tree().create_timer(3).timeout
	velocity = old_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += velocity
	if position.x > MAX_X or position.x < MIN_X:
		velocity*=-1
