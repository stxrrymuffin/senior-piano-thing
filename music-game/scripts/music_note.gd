extends Node2D

var note_type := 0
signal note_changed(note_type: int)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if note_type == 0:
			note_type = 1
			$sharp.visible = true
			$flat.visible = false
		elif note_type == 1:
			note_type = -1
			$flat.visible = true
			$sharp.visible = false
		else:
			note_type = 0
			$sharp.visible = false
			$flat.visible = false
		emit_signal("note_changed", self, note_type)
