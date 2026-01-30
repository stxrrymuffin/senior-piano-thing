extends Area2D

var velocity = Vector2(0, 0)
var on_ground = false
var max_distance = 500

func _process(delta):
	if position.y <= max_distance:
		velocity.y += gravity * delta
		position += velocity * delta
		rotation = velocity.angle()
	else:
		if on_ground: return
		_bob(position.y)
		on_ground = true
	
func _bob(cur_pos) -> void:
	var tween1 = create_tween()
	tween1.tween_property(self, "position", Vector2(position.x,cur_pos-20), 0.3).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(self, "position", Vector2(position.x,cur_pos+10), 0.5).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(self, "position", Vector2(position.x,cur_pos-10), 1).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(self, "position", Vector2(position.x, cur_pos), 1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1.5).timeout
	var tween2 = create_tween()
	tween2.set_loops()
	tween2.tween_property(self, "position", Vector2(position.x,cur_pos+10), 3).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(self, "position", Vector2(position.x, cur_pos-10), 3).set_trans(Tween.TRANS_SINE)
