extends Node2D

signal finished_rhythm(success)

const START_KEY := 21
const END_KEY := 108

var delta_sum_: float = 0.0
var left: Array = []

@onready var notes := {
	60: {
		"color": Color.PURPLE,
		"key": "ui_left",
		"node": $buttons/left,
		"queue": []
	},
	61: {
		"color": Color.AQUA,
		"key": "ui_up",
		"node": $buttons/up,
		"queue": []
	},
	62: {
		"color": Color.BLUE,
		"key": "ui_down",
		"node": $buttons/down,
		"queue": []
	},
	63: {
		"color": Color.RED,
		"key": "ui_right",
		"node": $buttons/right,
		"queue": []
	}
}

var animation := {
	36: {
		"call": "kick",
	},
	37: {
		"call": "snare",
	},
	38: {
		"call": "hat_closed",
	},
	39: {
		"call": "hat_open",
	}
}

var animation_queue: Array = []

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	delta_sum_ += delta

	for s in notes.values():
		if Input.is_action_just_pressed(s["key"]):
			if not s["queue"].is_empty():
				if s["queue"].front().test_hit(delta_sum_):
					var note = s["queue"].pop_front()
					note.hit(s["node"].global_position)
					display_play("Perfect")
				else:
					display_play("Early")
			else:
				print("miss")

		if not s["queue"].is_empty():
			if s["queue"].front().test_miss(delta_sum_):
				var note = s["queue"].pop_front()
				note.miss()
				display_play("Miss")

	for s in notes.values():
		s["node"].pressed = Input.is_action_pressed(s["key"])

	if delta_sum_ >= 1.0 and not $music.playing:
		$music.play()


func _on_midi_event(channel, event) -> void:
	if channel.track_name == "animation":

		var s = notes.get(event.note)
		print(event.type)
		if s != null and event.type == 144:
			var i = preload("./note.tscn").instantiate()
			
			var my_int = randi_range(1, 3)
			#if my_int == 1:
			#	i.play("eighth")
			#else:
		#		i.play("quarter")
			i.play("quarter")

			add_child(i)
			print('hallooooo')
			i.expected_time = delta_sum_ + 1.0
			i.global_rotation = s["node"].global_rotation
			i.global_position.y = s["node"].global_position.y
			i.global_position.x = 880
			i.color = s["color"]

			s["queue"].push_back(i)

func display_play(type):
	print('hi')
	$"Play Type".text = type + "!"
	$"Play Type".modulate.a = 1
	await get_tree().create_timer(0.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($"Play Type", "modulate:a", 0, 0.1)
	
func _on_button_pressed() -> void:
	finished_rhythm.emit(true)


func _on_button_2_pressed() -> void:
	finished_rhythm.emit(false)
