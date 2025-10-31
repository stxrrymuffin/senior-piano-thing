extends Node2D

var cur_note = 0
var note_lst = [0]
var note_node_lst = [0]
var note_ledger_lst = [0] #TODO
var cur_octave = 0

var ledger_line_scene = preload("res://scenes/ledger.tscn")
var note_scene = preload("res://scenes/music_note.tscn")
var a440_scene = preload("res://assets/A440.wav")
var rest_scene = preload("res://scenes/rest.tscn")

@onready var highlight = $"Selected Note"

const line_space = 22
const note_space = 120
const notes_per_line = 10

var cur_midi_map = Globals.note_map_midi_sharp
var cur_note_length = 0 #default, quarter

var play_from = 0
var cur_playing = false

var tempo = 120 #default

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
	$CanvasLayer/Button.focus_mode = Control.FOCUS_NONE 
	$CanvasLayer/accidentalType.focus_mode = Control.FOCUS_NONE 
	$"CanvasLayer/Note Select Button".note_length_changed.connect(set_cur_note_length)
	
func set_zoom(delta: Vector2) -> void:
	var mouse_pos := get_global_mouse_position()
	if ($Camera2D.zoom+delta) != Vector2(0,0):
		$Camera2D.zoom += delta
	var new_mouse_pos := get_global_mouse_position()
	$Camera2D.position += mouse_pos - new_mouse_pos
	
func _input(event):
	
	#check if MIDI input
	if event is InputEventMIDI:
		if event.channel == 0 and event.message == MIDI_MESSAGE_NOTE_ON:
			print("pitch", event.pitch)
			var new_note = event.pitch
			place_note(new_note, play_from)
			
	if event.is_action_pressed("Delete"):
		delete_note()
		
	if event.is_action_pressed("Confirm"):
		if note_node_lst[play_from] is not int:
			confirm_note()
		
	#check if key input
	elif event is InputEventKey and not event.echo and event.pressed:
		#print(event['keycode'])
		if event["keycode"] == 4194320:
			cur_octave += 1
		elif event["keycode"] == 4194322:
			cur_octave -= 1
		elif event["keycode"] == 4194319:
			select_note(max(play_from - 1, 0))
		elif event["keycode"] == 4194321:
			select_note(min(play_from + 1, cur_note + 1))
		#if key pressed is designated music note
		elif [event['keycode']] in Globals.note_map_keyboard:
			var new_note = Globals.note_map_keyboard[[event['keycode']]]
			place_note(new_note,play_from)
	
	#scroll using mouse wheel
	#if event is InputEventMouse:
	#	if event.is_pressed() and not event.is_echo():
	#		var mouse_position = event.position
	#		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
	#			set_zoom(Vector2(1,1))
	#		else : if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
	#			set_zoom(Vector2(-1,1))

func select_note(updated_note):
	if updated_note == cur_note + 1:
		print(note_lst[play_from])
		if note_lst[play_from] is not int or note_lst[play_from] != 0:
			confirm_note()
		else:
			return
	var y_pos = -115
	play_from = updated_note
	var x_pos = -212 + (play_from%notes_per_line)*note_space
	var init_y_pos = ($staff.texture.get_height() + 100)*floor(play_from/notes_per_line)

	highlight.position = Vector2(x_pos, y_pos + init_y_pos)
	play_note(note_lst[play_from])

func place_note(new_note, note_idx):
	print(note_node_lst)
	
	#add additional lines if amt of notes on line is maxed out
	if note_idx%notes_per_line == notes_per_line/2 and note_idx == (len(note_node_lst)-1):
		var copied_node = $staff2.duplicate()
		$staff2.get_parent().add_child(copied_node)
		copied_node.position.y = $staff.position.y + ($staff.texture.get_height()+100)*floor(note_idx/notes_per_line)
		copied_node.position.x = $staff.position.x + $staff.texture.get_width() - 200
		copied_node.visible = true
	#add new music staff if amt of notes on line is maxed out
	if note_idx%notes_per_line == 0 and note_idx != 0 and note_idx == (len(note_node_lst)-1):
		var copied_node = $staff.duplicate()
		$staff.get_parent().add_child(copied_node)
		copied_node.position.y = $staff.position.y + ($staff.texture.get_height()+100)*floor(note_idx/notes_per_line)
	
	#load in music note display
	if note_node_lst[note_idx] is not int:
		for node in note_node_lst[note_idx]:
			node.queue_free()
	elif note_node_lst[note_idx] != 0:
		for node in note_node_lst[note_idx]:
			node.queue_free()
	var new_note_scene = note_scene.instantiate()
	new_note_scene.note_changed.connect(note_on_click)
	var x_pos = -180 + (note_idx%notes_per_line)*note_space
	var y_pos = 0
	var init_y_pos = ($staff.texture.get_height() + 100)*floor(note_idx/notes_per_line)
	
	var midi_input = false
	#if keyboard input, set position to current octave & note
	if new_note is not int:
		y_pos = -1*line_space* (7 * cur_octave + Globals.pos_map[new_note])
		new_note_scene.position = Vector2(x_pos, y_pos + init_y_pos)
		note_lst[note_idx] = new_note + str(cur_octave)
	#if midi input, set position to note played
	else:
		y_pos = -1*line_space* (7*(int(new_note/12)-4) + Globals.pos_map[cur_midi_map[new_note%12][0]])
		new_note_scene.position = Vector2(x_pos, y_pos + init_y_pos)
		#show accidental
		if "#" in cur_midi_map[new_note%12]:
			new_note_scene.set_sharp()
		elif "b" in cur_midi_map[new_note%12]:
			new_note_scene.set_flat()
		note_lst[note_idx] = cur_midi_map[new_note%12] + str(int(new_note/12)-4)
		midi_input = true
	new_note_scene.set_note(cur_note_length)
	add_child(new_note_scene)
	play_note(note_lst[note_idx])
	note_node_lst[note_idx] = [new_note_scene]
	
	# too high of a note, place ledger line
	if y_pos >= 6*line_space:
		for i in range(6*line_space, y_pos+1, line_space*2):
			var ledger_line = ledger_line_scene.instantiate()
			ledger_line.position = Vector2(x_pos, i + init_y_pos)
			add_child(ledger_line)
			note_node_lst[note_idx] += [ledger_line]
	# too low of a note, place ledger line
	elif y_pos <= -6*line_space:
		for i in range(-6*line_space, y_pos-1, -line_space*2):
			var ledger_line = ledger_line_scene.instantiate()
			ledger_line.position = Vector2(x_pos, i + init_y_pos)
			add_child(ledger_line)
			note_node_lst[note_idx] += [ledger_line]
	
	if note_node_lst[note_idx] is not int and midi_input:
		confirm_note()
			
func confirm_note():
	# on enter, "confirms" note and adds to list
	if str(note_lst[cur_note]) != '0':
		cur_note += 1
		note_lst += [0]
		note_node_lst += [0]
	select_note(play_from+1)

func first_digit_idx(string):
	# get first digit's idx of a string 
	for i in range(len(string)):
		if string[i] in "123456790-":
			return i
	
func play_note(note):
	#play note audio, note = C, D, E ... OR note = 60, 61, 62...
	if note is not String: return
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = a440_scene
	audio.pitch_scale = pow(2, (Globals.note_to_pitch[note.substr(0,first_digit_idx(note))] + 12*int(note.substr(1,len(note))) - 69.0) / 12.0)
	audio.play()
	
func delete_note():
	#delete previously confirmed note
	#if there is already a temporary note selected, delete it
	if note_node_lst[play_from] is not int: 
		var note_x = note_node_lst[play_from][0].position.x
		var note_y = note_node_lst[play_from][0].position.y
		var note_length = note_node_lst[play_from][0].note_length
		for node in note_node_lst[play_from]:
			node.queue_free()
		place_rest(note_x, note_y, note_length)
		#note_node_lst[play_from] = 0
		note_lst[play_from] = 1
	#else, delete prev confirmed note
	#elif cur_note > 0:
	#	for node in note_node_lst[-2]:
	#		node.queue_free()
	#	note_node_lst.remove_at(note_node_lst.size()-2)
	#	note_lst.remove_at(note_lst.size()-2)
	#	cur_note -= 1
	
func place_rest(note_x, note_y, note_length):
	print("place rest")
	print(note_x, ($staff.texture.get_height() + 100)*floor(play_from/notes_per_line), note_length)
	var rest_node = rest_scene.instantiate()
	rest_node.rest_changed.connect(rest_on_click)
	rest_node.position = Vector2(note_x, ($staff.texture.get_height() + 100)*floor(play_from/notes_per_line))
	add_child(rest_node)
	rest_node.set_note(note_length)
	note_node_lst[play_from] = [rest_node]
	print(note_node_lst)

func _on_button_pressed():
	#play current transcription when button pressed
	var play_notes_lst = note_lst.slice(play_from,note_lst.size())
	if note_lst[-1] is int and note_lst[-1] == 0: play_notes_lst = play_notes_lst.slice(0,-1)
	
	$CanvasLayer/Button.disabled = true
	for i in range(play_notes_lst.size()):
		play_note(play_notes_lst[i])
		if note_node_lst[play_from] is int: continue
		if note_node_lst[play_from][0].note_length == 0:
			print('hi')
			print((60)/float(tempo))
			print(tempo)
			await get_tree().create_timer((60)/float(tempo)).timeout
		elif note_node_lst[play_from][0].note_length == 1:
			await get_tree().create_timer(2*60/tempo).timeout
		elif note_node_lst[play_from][0].note_length == 2:
			await get_tree().create_timer(0.5*60/tempo).timeout
		else:
			await get_tree().create_timer(0.25*60/tempo).timeout
		if i != play_notes_lst.size()-1:
			select_note(play_from+1)
	$CanvasLayer/Button.disabled = false

func note_on_click(node, note_type):
	if cur_playing: return
	print(node)
	print(note_type)
	print(note_lst[cur_note])
	print(note_lst)
	
	#TODO make this more efficient
	var lst_nodes = []
	for note in note_node_lst:
		if note is not int:
			lst_nodes += [note[0]]
	var clicked_note = lst_nodes.find(node)
	
	if note_type == 1:
		note_lst[clicked_note] = note_lst[clicked_note][0] + "#" + note_lst[clicked_note].substr(1,note_lst[clicked_note].length())
	elif note_type == -1:
		note_lst[clicked_note] = note_lst[clicked_note].replace("#", "b")
	else:
		note_lst[clicked_note] = note_lst[clicked_note][0] + note_lst[clicked_note].substr(2,note_lst[clicked_note].length())
	play_note(note_lst[clicked_note])
	select_note(clicked_note)
	
func rest_on_click(node, note_length):
	if cur_playing: return
	var lst_nodes = []
	for note in note_node_lst:
		if note is not int:
			lst_nodes += [note[0]]
	var clicked_note = lst_nodes.find(node)
	select_note(clicked_note)
	
func set_cur_note_length(note_length):
	cur_note_length = note_length

func _on_accidental_type_pressed():
	if cur_midi_map == Globals.note_map_midi_sharp:
		$CanvasLayer/accidentalType.text = "MIDI Accidental: Flat"
		cur_midi_map = Globals.note_map_midi_flat
	else:
		$CanvasLayer/accidentalType.text = "MIDI Accidental: Sharp"
		cur_midi_map = Globals.note_map_midi_sharp


func _on_texture_button_pressed():
	$CanvasLayer/instructions.visible = false

func _on_instruc_button_pressed():
	$CanvasLayer/instructions.visible = true


func _on_h_slider_value_changed(value):
	tempo = value
	$CanvasLayer/HSlider/Label.text = "Current Tempo: " + str(int(tempo)) + " BPM"
