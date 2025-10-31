extends Node2D

var note_type := 0
var note_length := 1
signal note_changed(note_type: int)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Globals.cur_playing: return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if note_type == 0:
			set_sharp()
		elif note_type == 1:
			set_flat()
		else:
			note_type = 0
			$sharp.visible = false
			$flat.visible = false
		emit_signal("note_changed", self, note_type)

func set_sharp():
	note_type = 1
	$sharp.visible = true
	$flat.visible = false
	
func set_flat():
	note_type = -1
	$flat.visible = true
	$sharp.visible = false
	
func set_note(note):
	if note == 0:
		$AnimatedSprite2D.play("quarter")
	elif note == 1:
		$AnimatedSprite2D.play("half")
	elif note == 2:
		$AnimatedSprite2D.play("eighth")
	else:
		$AnimatedSprite2D.play("sixteenth")
	note_length = note
