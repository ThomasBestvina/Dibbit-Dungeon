extends Container

@export var values: Array = [5,4,2,6,1,0]
@export var color: Color = Color.BLACK

var cur_value = 0
func _ready() -> void:
	$AnimatedSprite2D.frame = values[0]
	$AnimatedSprite2D.modulate = color

func _on_timer_timeout() -> void:
	cur_value += 1
	cur_value %= len(values)
	$AnimatedSprite2D.frame = values[cur_value]
