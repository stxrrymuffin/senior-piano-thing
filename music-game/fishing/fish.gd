extends CharacterBody2D

const TEMP_MIN_X = 300
const TEMP_MAX_X = 1100

var MIN_Y = 350
var MAX_Y = 650
var MIN_X = 300
var MAX_X = 1100
var velocity_fish = 0.5

var DISTRESSED = false
var fish_type = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index=-5
	assign_rand_range()
	position.x = randf_range(MIN_X, MAX_X)
	position.y = randf_range(MIN_Y, MAX_Y)
	velocity_fish = randf_range(0.1,1)
	fish_type = randi_range(0,1)
	if fish_type == 0:
		$AnimatedSprite2D.play("fish1")
	else:
		$AnimatedSprite2D.play("fish2")
		
func flip_fish():
	velocity_fish *= -1
	scale.x *= -1

func distressed():
	print('distressed')
	DISTRESSED = true
	var old_velocity_fish = abs(velocity_fish)
	if velocity_fish > 0:
		velocity_fish = 2
	else: 
		velocity_fish = -2
	await get_tree().create_timer(3).timeout
	if velocity_fish > 0:
		velocity_fish = old_velocity_fish
	else: 
		velocity_fish = -old_velocity_fish
	DISTRESSED = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += velocity_fish
	if DISTRESSED:
		if position.x > TEMP_MAX_X or position.x < TEMP_MIN_X:
			flip_fish()
	else:
		if position.x > MAX_X:
			velocity_fish = -abs(velocity_fish)
			scale.x = -abs(scale.x )
		elif position.x < MIN_X:
			velocity_fish = abs(velocity_fish)
			scale.x = abs(scale.x )

func assign_rand_range():
	MIN_X = randf_range(MIN_X, MAX_X)
	MAX_X = randf_range(MIN_X, MAX_X)
	while abs(MIN_X-MAX_X) < 100:
		MIN_X = 100
		MAX_X = 1100
		MIN_X = randf_range(MIN_X, MAX_X)
		MAX_X = randf_range(MIN_X, MAX_X)
