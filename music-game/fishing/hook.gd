extends Area2D

var velocity = Vector2(0, 0)
var on_ground = false
var new_on_ground = false
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
	new_on_ground = true
	var tween1 = create_tween()
	tween1.tween_property(self, "position", Vector2(position.x,cur_pos+10), 0.3).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(self, "position", Vector2(position.x,cur_pos-10), 0.5).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(self, "position", Vector2(position.x,cur_pos+6), 0.5).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(self, "position", Vector2(position.x, cur_pos), 0.5).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1.8).timeout
	new_on_ground = false
	var tween2 = create_tween()
	tween2.set_loops()
	tween2.tween_property(self, "position", Vector2(position.x,cur_pos+10), 3).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(self, "position", Vector2(position.x, cur_pos-10), 3).set_trans(Tween.TRANS_SINE)



func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if on_ground and not new_on_ground:
		var rand_num = randf_range(0,1)
		print(rand_num)
		if rand_num > 0.5:
			area.get_parent().INTERESTED = true
			print('fish interested')
		else:
			area.get_parent().distressed()
	else:
		if not area.get_parent().DISTRESSED:
			area.get_parent().flip_fish()
			area.get_parent().distressed()

func _on_body_entered(body):
	if on_ground and not new_on_ground:
		print('fish hit')
		print(body.DISTRESSED)
		if body.DISTRESSED and not body.ALR_DISTRESSED:
			body.ALR_DISTRESSED = true
			body.distressed()
		print(body.ALR_DISTRESSED)
	else:
		body.distressed()
