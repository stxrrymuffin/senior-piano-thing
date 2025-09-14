extends Node2D

var cur_note = 0
var note_lst = [0]
var note_node_lst = [0]
var cur_octave = 0

var ledger_line_scene = preload("res://scenes/ledger.tscn")
var note_scene = preload("res://scenes/music_note.tscn")
var a440_scene = preload("res://assets/A440.wav")

const line_space = 22
const note_space = 100

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
			confirm_note()
		
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
		for node in note_node_lst[cur_note]:
			node.queue_free()
	elif note_node_lst[cur_note] != 0:
		for node in note_node_lst[cur_note]:
			node.queue_free()
	var new_note_scene = note_scene.instantiate()
	new_note_scene.note_changed.connect(note_on_click)
	var x_pos = -180 + cur_note*note_space
	var y_pos = 0
	#if keyboard input, set position to current octave & note
	if new_note is not int:
		y_pos = -1*line_space* (7 * cur_octave + Globals.pos_map[new_note])
		new_note_scene.position = Vector2(x_pos, y_pos)
		note_lst[cur_note] = new_note + str(cur_octave)
	#if midi input, set position to note played
	else:
		y_pos = -1*line_space* (7*(int(new_note/12)-4) + Globals.pos_map[Globals.note_map_midi[new_note%12]])
		new_note_scene.position = Vector2(x_pos, y_pos)
		print(new_note)
		note_lst[cur_note] = Globals.note_map_midi[new_note%12] + str(int(new_note/12)-4)
	
	add_child(new_note_scene)
	play_note(note_lst[cur_note])
	note_node_lst[cur_note] = [new_note_scene]
	
	# too high of a note, place ledger line
	if y_pos >= 6*line_space:
		for i in range(6*line_space, y_pos+1, line_space*2):
			var ledger_line = ledger_line_scene.instantiate()
			ledger_line.position = Vector2(x_pos, i)
			add_child(ledger_line)
			note_node_lst[cur_note] += [ledger_line]
	# too low of a note, place ledger line
	elif y_pos <= -6*line_space:
		for i in range(-6*line_space, y_pos-1, -line_space*2):
			var ledger_line = ledger_line_scene.instantiate()
			ledger_line.position = Vector2(x_pos, i)
			add_child(ledger_line)
			note_node_lst[cur_note] += [ledger_line]
			
func confirm_note():
	if str(note_lst[cur_note]) != '0':
		cur_note += 1
		note_lst += [0]
		note_node_lst += [0]
	
func play_note(note):
	#play note audio, note = C, D, E ... OR note = 60, 61, 62...
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = a440_scene
	audio.pitch_scale = pow(2, (Globals.note_to_pitch[note[0]] + 12*int(note.substr(1,len(note))) - 69.0) / 12.0)
	audio.play()
	
func delete_note():
	#delete previously confirmed note
	#TODO make it so that arrow keys can navigate between notes & delete specified ones
	print(note_node_lst)
	print(note_lst)
	#if there is already a temporary note selected, delete it
	if note_node_lst[-1] is not int: 
		for node in note_node_lst[-1]:
			node.queue_free()
		note_node_lst[-1] = 0
		note_lst[-1] = 0
	#else, delete prev confirmed note
	elif cur_note > 0:
		for node in note_node_lst[-2]:
			node.queue_free()
		note_node_lst.remove_at(note_node_lst.size()-2)
		note_lst.remove_at(note_lst.size()-2)
		cur_note -= 1

func _on_button_pressed():
	#play current transcription when button pressed
	var play_notes_lst = note_lst
	if note_lst[-1] is int: play_notes_lst = note_lst.slice(0,-1)
	for i in range(play_notes_lst.size()):
		play_note(play_notes_lst[i])
		await get_tree().create_timer(0.5).timeout

func note_on_click(note_type):
	print(note_type)
