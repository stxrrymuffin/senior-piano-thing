extends Node
var cur_playing = false
const note_map_keyboard = {
	[65]:"C",
	[83]:"D",
	[68]:"E",
	[70]:"F",
	[71]:"G",
	[72]:"A",
	[74]:"B",
	[75]:"H" #c2 lol
}

const note_map_midi_sharp= {
	0:"C",
	1:"C#",
	2:"D",
	3:"D#",
	4:"E",
	5:"F",
	6:"F#",
	7:"G",
	8:"G#",
	9:"A",
	10:"A#",
	11:"B"
}

const note_map_midi_flat= {
	0:"C",
	1:"Db",
	2:"D",
	3:"Eb",
	4:"E",
	5:"F",
	6:"Gb",
	7:"G",
	8:"Ab",
	9:"A",
	10:"Bb",
	11:"B"
}

const note_to_pitch = {
	"Cb" = 59,
	"C" = 60,
	"C#" = 61,
	"Db" = 61,
	"D" = 62,
	"D#" = 63,
	"Eb" = 63,
	"E" = 64,
	"Fb" = 64,
	"E#" = 65,
	"F" = 65,
	"F#" = 66,
	"Gb" = 66,
	"G" = 67,
	"G#" = 68,
	"Ab" = 68,
	"A" = 69,
	"A#" = 70,
	"Bb" = 70,
	"B" = 71,
	"Hb" = 71,
	"B#" = 72,
	"H" = 72,
	"H#" = 73
}

const pos_map = {
	"C": -6,
	"D": -5,
	"E": -4,
	"F": -3,
	"G" : -2,
	"A" : -1,
	"B": 0,
	"H": 1
}
