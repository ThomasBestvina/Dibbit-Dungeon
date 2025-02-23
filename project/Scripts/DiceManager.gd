extends HFlowContainer

@onready var dierep = preload("res://Objects/DieRep.tscn")

@onready var trash: Area2D = get_parent().get_node("Trash/Area2D")

var hover_trash = false

var dragged_item: Panel = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trash.connect("mouse_entered",_trash_entered)
	trash.connect("mouse_exited",_trash_left)
	for i in get_children():
		if i.name != "Trash":
			i.connect("mouse_on_me", _on_die_entered)
			i.connect("mouse_not_on_me", _on_die_left)
	
	add_die([1,2,3,4,5,6],Color.WEB_GRAY)
	
	for i in range(1):
		var die = Lookup.generate_die()
		add_die(die[0],die[1])



func add_die(value,col):
	var die = dierep.instantiate()
	die.connect("mouse_on_me", _on_die_entered)
	die.connect("mouse_not_on_me", _on_die_left)
	die.values = value
	die.color = col
	add_child(die)

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
			if(hover_trash):
				PlayerResources.money += PlayerResources.round*1.25
				dragged_item.queue_free()
				get_parent().get_node("TrashItem").play()
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


func _on_shop_bought_die(values: Variant, color: Variant) -> void:
	add_die(values,color)

func _trash_entered():
	hover_trash = true
	trash.get_parent().frame = 1

func _trash_left():
	hover_trash = false
	trash.get_parent().frame = 0
