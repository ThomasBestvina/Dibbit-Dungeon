class_name DiceRep extends Panel

signal mouse_on_me(pan: Panel)
signal mouse_not_on_me(pan: Panel)

@export var values: Array = [5,4,2,6,1,0]
@export var color: Color = Color.BLACK

var cur_value = randi_range(0,len(values))
func _ready() -> void:
	$Sprite2D/AnimatedSprite2D.frame = values[0]
	$Sprite2D.self_modulate = color

func _on_timer_timeout() -> void:
	cur_value += 1
	cur_value %= len(values)
	$Sprite2D/AnimatedSprite2D.frame = values[cur_value]


func _on_mouse_entered() -> void:
	emit_signal("mouse_on_me",self)


func _on_mouse_exited() -> void:
	emit_signal("mouse_not_on_me",self)
