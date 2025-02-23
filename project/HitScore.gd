extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a  = lerp(modulate.a, 0.0, 0.02)
	if modulate.a  <= 0.1:
		queue_free()


func _on_timer_timeout() -> void:
	var offset_y = 2
	position = position - Vector2(0, offset_y)
