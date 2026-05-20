extends Node2D
@onready var rhythm_scene = preload("res://battle_system/rhythm.tscn")
@export var dialogue_resource: DialogueResource

var PLAYER_HEALTH = 100
var ENEMY_HEALTH = 100
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_attack_pressed():
	pass
	
func _on_skill_pressed():
	var rhy_scene = rhythm_scene.instantiate()
	rhy_scene.finished_rhythm.connect(cast_skill.bind("meow", rhy_scene))
	add_child(rhy_scene)
	
func _on_item_pressed():
	pass # Replace with function body.

func cast_skill(success, skill_name, rhy_scene):
	rhy_scene.queue_free()
	if not success: return
	if skill_name == "meow":
		ENEMY_HEALTH -= 10
		$Enemy/ProgressBar2.value = ENEMY_HEALTH
	DialogueManager.show_dialogue_balloon(load("res://main_world_scenes/dialogues/test.dialogue"), "start")
	
func enemy_attack():
	print('hello')
	rng.randomize()
	var rand_num = rng.randi_range(1, 10) 
	if rand_num < 5:
		PLAYER_HEALTH -= 10
	elif rand_num < 7:
		PLAYER_HEALTH -= 15
	else: 
		PLAYER_HEALTH -= 20
	var tween1 = create_tween()
	tween1.tween_property($Player/ProgressBar, "value", PLAYER_HEALTH, 0.3).set_trans(Tween.TRANS_SINE)
	await tween1.finished
	#$Player/ProgressBar.value = PLAYER_HEALTH
	DialogueManager.show_dialogue_balloon(load("res://battle_system/dialogue/enemy_atk1.dialogue"), "start")
