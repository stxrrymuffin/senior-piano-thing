extends CharacterBody2D

const TEMP_MIN_X = 0
const TEMP_MAX_X = 1100

var MIN_Y = 360
var MAX_Y = 600
var MIN_X = 300
var MAX_X = 1100
var speed = 0.5
var velocity_fish = 0.5
var old_velocity_fish = 0.5

var DISTRESSED = false
var ALR_DISTRESSED = false
var INTERESTED = false
var fish_type = 0

var frequency: float = 5.0
var amplitude: float = 0.5
var time_passed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	assign_rand_range()
	position.x = randf_range(MIN_X, MAX_X)
	position.y = randf_range(MIN_Y, MAX_Y)
	speed = randf_range(0.2,1)
	amplitude = randf_range(0.2,0.5)
	frequency = randf_range(3.0, 6.0)
	fish_type = randi_range(0,2)
	if fish_type == 0:
		$AnimatedSprite2D.play("fish1")
	elif fish_type == 1:
		$AnimatedSprite2D.play("fish2")
	else:
		$AnimatedSprite2D.play("fish3")
		
func flip_fish():
	speed *= -1
	scale.x *= -1

func distressed():
	#print('distressed')
	DISTRESSED = true
	if speed > 0:
		speed = 2
	else: 
		speed = -2
	$Timer.stop()
	$Timer.wait_time = randi_range(3,7) 
	$Timer.start()
	print('timer called')

func unstressed():
	print("in unstressed statement")
	print(DISTRESSED)
	print(ALR_DISTRESSED)
	if not DISTRESSED: return
	if ALR_DISTRESSED:
		ALR_DISTRESSED = false
		return
	if velocity_fish.x > 0:
		speed = 0.5
	else: 
		speed = -0.5
	ALR_DISTRESSED = false
	DISTRESSED = false
	print("end distressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Label.text = str($Timer.time_left)
	time_passed += delta
	var rotation_fish = sin(time_passed * frequency) * amplitude
	velocity_fish = Vector2(cos(rotation_fish), sin(rotation_fish)) * speed
	
	if not INTERESTED:
		position += velocity_fish
	if DISTRESSED:
		if position.x > TEMP_MAX_X or position.x < TEMP_MIN_X:
			flip_fish()
	elif not INTERESTED:
		if position.x > MAX_X:
			speed = -abs(speed)
			scale.x = -abs(scale.x )
		elif position.x < MIN_X:
			speed = abs(speed)
			scale.x = abs(scale.x )

func assign_rand_range():
	MIN_X = randf_range(MIN_X, MAX_X)
	MAX_X = randf_range(MIN_X, MAX_X)
	while abs(MIN_X-MAX_X) < 300:
		MIN_X = 100
		MAX_X = 1100
		MIN_X = randf_range(MIN_X, MAX_X)
		MAX_X = randf_range(MIN_X, MAX_X)

func _on_timer_timeout():
	unstressed()
