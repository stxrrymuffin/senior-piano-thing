extends Node2D

var cur_note = 0
var note_lst = [0]
var note_node_lst = [0]
var cur_octave = 0

# A standard piano with 88 keys has keys from 21 to 108.
# To get a different set of keys, modify these numbers.
# A maximally extended 108-key piano goes from 12 to 119.
# A 76-key piano goes from 23 to 98, 61-key from 36 to 96,
# 49-key from 36 to 84, 37-key from 41 to 77, and 25-key
# from 48 to 72. Middle C is pitch number 60, A440 is 69.
func _ready():
	DiscordRPC.app_id = 1413361468811776020
	DiscordRPC.state = "Playing"
	DiscordRPC.details = "im suffering"
	DiscordRPC.refresh()
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	$Button.focus_mode = Control.FOCUS_NONE 
	
func _input(event):
	#check if MIDI input
	if event is InputEventMIDI:
		if event.channel == 0 and event.message == MIDI_MESSAGE_NOTE_ON:
			print("pitch", event.pitch)
			#if [event.pitch] in Globals.note_map_midi:
			var new_note = event.pitch
			place_note(new_note)
			
	if event.is_action_pressed("Delete"):
		delete_note()
		
	if event.is_action_pressed("Confirm"):
		if note_node_lst[cur_note] is not int:
			confirm_note(cur_note)
		
	#check if key input
	elif event is InputEventKey and not event.echo and event.pressed:
		print(event['keycode'])
		if event["keycode"] == 4194320:
			cur_octave += 1
		elif event["keycode"] == 4194322:
			cur_octave -= 1
		#if key pressed is designated music note
		elif [event['keycode']] in Globals.note_map_keyboard:
			var new_note = Globals.note_map_keyboard[[event['keycode']]]
			place_note(new_note)

func place_note(new_note):
	
	#load in music note display
	if note_node_lst[cur_note] is not int:
		print(note_node_lst[cur_note])
		note_node_lst[cur_note].queue_free()
	elif note_node_lst[cur_note] != 0:
		print(note_node_lst[cur_note])
		note_node_lst[cur_note].queue_free()
	var new_note_scene = preload("res://scenes/music_note.tscn").instantiate()
	
	#if keyboard input
	if new_note is not int:
		new_note_scene.position = Vector2(-180 + cur_note*80, -22*7 * cur_octave + -22 * Globals.pos_map[new_note])
		add_child(new_note_scene)
		play_note(new_note+str(cur_octave))
		note_lst[cur_note] = new_note + str(cur_octave)
	#if midi input
	else:
		new_note_scene.position = Vector2(-180 + cur_note*80, -22*7 * (int(new_note/12)-4) + -22 * Globals.pos_map[Globals.note_map_midi[new_note%12]])
		add_child(new_note_scene)
		play_note(new_note)
		note_lst[cur_note] = new_note + str(int(new_note/12)-4)
	note_node_lst[cur_note] = new_note_scene
			
func confirm_note(note):
	cur_note += 1
	note_lst += [0]
	note_node_lst += [0]
	
func play_note(note):
	#play note audio, note = C, D, E ... OR note = 60, 61, 62...
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = preload("res://assets/A440.wav")
	if note is not int:
		audio.pitch_scale = pow(2, (Globals.note_to_pitch[note[0]] + 12*int(note[1]) - 69.0) / 12.0)
	else:
		audio.pitch_scale = pow(2, (note - 69.0) / 12.0)
	audio.play()
	
func delete_note():
	#delete previously confirmed note
	#TODO make it so that arrow keys can navigate between notes & delete specified ones
	if cur_note > 0:
		note_node_lst[-2].queue_free()
		note_node_lst.remove_at(note_node_lst.size()-2)
		note_lst.remove_at(note_lst.size()-2)
		print(note_node_lst)
		print(note_lst)
		cur_note -= 1

func _on_button_pressed():
	#play current transcription when button pressed
	var play_notes_lst = note_lst
	if note_lst[-1] is int: play_notes_lst = note_lst.slice(0,-1)
	for i in range(play_notes_lst.size()):
		play_note(play_notes_lst[i])
		await get_tree().create_timer(0.5).timeout
