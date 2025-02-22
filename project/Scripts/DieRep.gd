class_name DiceRep extends Panel

signal mouse_on_me(pan: Panel)
signal mouse_not_on_me(pan: Panel)

@export var values: Array = [5,4,2,6,1,0]
@export var color: Color = Color.BLACK

var cur_value = randi_range(0,len(values))
func _ready() -> void:
	init()

func init() -> void:
	$Sprite2D/AnimatedSprite2D.frame = values[0]
	$Sprite2D.self_modulate = color
	$Sprite2D/RichTextLabel.text = "[center]"
	for i in values:
		match Lookup.lookup_operation(i):
			"+":
				$Sprite2D/RichTextLabel.text += "[color=FFFFFF]"
			"*":
				$Sprite2D/RichTextLabel.text += "[color=00ccff]"
			"/":
				$Sprite2D/RichTextLabel.text += "[color=ff0000]"
			"-":
				$Sprite2D/RichTextLabel.text += "[color=ff6600]"
		$Sprite2D/RichTextLabel.text += (Lookup.lookup_operation(i) + str(Lookup.lookup_realval(i)) + "\n")

func _process(delta: float) -> void:
	if(Input.is_action_pressed("select")):
		$Sprite2D/RichTextLabel.hide()

func _on_timer_timeout() -> void:
	cur_value += 1
	cur_value %= len(values)
	$Sprite2D/AnimatedSprite2D.frame = values[cur_value]

func _on_mouse_entered() -> void:
	emit_signal("mouse_on_me",self)
	$Sprite2D/RichTextLabel.show()


func _on_mouse_exited() -> void:
	emit_signal("mouse_not_on_me",self)
	$Sprite2D/RichTextLabel.hide()
