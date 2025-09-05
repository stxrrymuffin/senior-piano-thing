extends Node2D

var cur_note = 0
var note_lst = []
var note_node_lst = []
var cur_octave = 0

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
func _input(event):
	#check if MIDI input
	if event is InputEventMIDI:
		if event.channel == 0:
			print("pitch", event.pitch)
			
	#check if key input
	elif event is InputEventKey and not event.echo and event.pressed:
		print(event['keycode'])
		if event["keycode"] == 4194320:
			cur_octave += 1
		elif event["keycode"] == 4194322:
			cur_octave -= 1
		#if key pressed is designated music note
		elif [event['keycode']] in Globals.note_map:
			var new_note = Globals.note_map[[event['keycode']]]
			#load in music note display
			var new_note_scene = preload("res://scenes/music_note.tscn").instantiate()
			new_note_scene.position = Vector2(-180 + cur_note*80, -22*7 * cur_octave + -22 * Globals.pos_map[new_note])
			add_child(new_note_scene)
			#update note list
			note_lst += [new_note]
			note_node_lst += [new_note_scene]
			cur_note += 1
