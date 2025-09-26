extends Node2D

signal note_length_changed(note_type: String)

func _ready():
	var option_button = $OptionButton
	option_button.select(0)
	for i in range(option_button.get_item_count()):
		option_button.get_popup().set_item_icon_max_width(i, 20)
	$OptionButton.focus_mode = Control.FOCUS_NONE 
	$OptionButton.item_selected.connect(_on_OptionButton_item_selected)

func _on_OptionButton_item_selected(index:int):
	print($OptionButton.get_item_text(index))
	emit_signal("note_length_changed", index)
	
