extends Node2D
var note_length := 0

func set_note(note):
	print(note)
	if note == 0:
		$AnimatedSprite2D.play("quarter")
	elif note == 1:
		$AnimatedSprite2D.play("half")
	elif note == 2:
		$AnimatedSprite2D.play("eighth")
	else:
		$AnimatedSprite2D.play("sixteenth")
	note_length = note

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		set_note((note_length+1)%4)
