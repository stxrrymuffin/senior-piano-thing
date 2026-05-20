extends Node2D
@onready var button_scene = preload("res://fishing/answer_button.tscn")
const starting_x = 650
var starting_y = 195
var correct_ans = ""

signal selected_ans(correct)

func _ready():
	var q_number = randi_range(1,len(Globals.dct_questions))
	$RichTextLabel.text = Globals.dct_questions[1]["Question"]
	$TextureRect.texture = load(Globals.dct_questions[1]["Image"])
	var q_answers = Globals.dct_questions[1]["Answers"].duplicate()
	correct_ans = Globals.dct_questions[1]["Answers"][0]
	randomize()
	q_answers.shuffle()
	for i in range(len(q_answers)): 
		var answer = button_scene.instantiate()
		answer.on_pressed.connect(check_answer)
		add_child(answer)
		answer.position = Vector2(starting_x, starting_y)
		answer.text = q_answers[i]
		starting_y += 40
	
	position.y = position.y + 200
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 200, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
func check_answer(button_node):
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 50, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	emit_signal("selected_ans", int(button_node.text == correct_ans))
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 50, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	print('hello.')
	emit_signal("selected_ans", 0)
	self.queue_free()
