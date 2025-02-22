extends HBoxContainer

var dragged_item: Panel = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: DiceRep in get_children():
		i.connect("mouse_on_me", _on_die_entered)
		i.connect("mouse_not_on_me", _on_die_left)

func get_player_die_values() -> Array:
	var values = []
	for i in get_children():
		values.append(i.values)
	return values

func get_player_die_colors() -> Array:
	var values = []
	for i in get_children():
		values.append(i.color)
	return values

func _on_die_entered(die):
	if(dragged_item == null):
		dragged_item = die
		dragged_item.set_focus_mode(Control.FOCUS_ALL)

func _on_die_left(die):
	if(dragged_item != null && !Input.is_action_pressed("select")):
		dragged_item.set_focus_mode(Control.FOCUS_NONE)
		dragged_item = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
		if dragged_item:
			var target_index = get_closest_index_to_mouse()
			if target_index != -1 and target_index != dragged_item.get_index():
				move_child(dragged_item, target_index)  # Reorder the nodes
			dragged_item.get_node("Sprite2D").global_position = dragged_item.get_node("Anchor").global_position 
			dragged_item = null

func _process(delta: float) -> void:
	if(Input.is_action_pressed("select")):
		if dragged_item:
			dragged_item.get_node("Sprite2D").global_position = get_viewport().get_mouse_position()


func get_closest_index_to_mouse() -> int:
	var mouse_position = get_global_mouse_position()
	var closest_index = -1
	var closest_distance = INF

	for i in range(get_child_count()):
		var child = get_child(i)
		var child_rect = child.get_node("Anchor")
		var distance = mouse_position.distance_to(child_rect.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_index = i
			
	return closest_index
