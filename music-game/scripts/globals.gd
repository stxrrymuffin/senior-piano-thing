extends Node
const note_map_keyboard = {
	[65]:"C",
	[83]:"D",
	[68]:"E",
	[70]:"F",
	[71]:"G",
	[72]:"A",
	[74]:"B",
}

const note_map_midi= {
	0:"C",
	2:"D",
	4:"E",
	5:"F",
	7:"G",
	9:"A",
	11:"B",
}

const note_to_pitch = {
	"C" = 60,
	"D" = 62,
	"E" = 64,
	"F" = 65,
	"G" = 67,
	"A" = 69,
	"B" = 71
}

const pos_map = {
	"C": -6,
	"D": -5,
	"E": -4,
	"F": -3,
	"G" : -2,
	"A" : -1,
	"B": 0,
}
