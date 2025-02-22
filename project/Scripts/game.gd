extends Control

@onready var roll_button: TextureButton = $BoxContainer/Roll
@onready var items_button: Button = $BoxContainer/Items
@onready var dice_spawner: spawner = $"SubViewport/DiceRoom"

@onready var ent_preload = preload("res://Objects/Entity.tscn")

var entities: Array[Entity] = []

var budget = 2

# Turn 0 means players turn.
var turn = 0

var selected: Entity = null

func _ready() -> void:
	entities.append($Players/Player)
	spawn_wave()
	_on_dice_room_die_finished([])

func _process(delta: float) -> void:
	if(turn != 0 || ( turn == 0 && selected == null ) ):
		roll_button.disabled = true
	else:
		roll_button.disabled = false
	for i in entities.duplicate():
		if(i.health <= 0):
			entities.erase(i)
			i.queue_free()
	if(len(dice_spawner.dice) > 0):
		var vals = dice_spawner.get_cur_values()
		$DiceMath.text = "[center]0"
		for i in vals:
			$DiceMath.text += Lookup.lookup_operation(i)
			$DiceMath.text += str(Lookup.lookup_realval(i))


func _on_dice_room_die_finished(values: Array) -> void:
	if(len(values) == 0): return
	
	var damage: int = 0
	for i in values:
		damage = Lookup.calculate(damage, i)
	if(turn == 0):
		selected.remove_health(damage)
	else:
		entities[0].remove_health(damage)
	for i in entities.duplicate():
		if(i.health <= 0):
			entities.erase(i)
			i.queue_free()
	turn += 1
	turn = turn % len(entities)
	handle_turn()

func handle_turn():
	if turn == 0: return
	dice_spawner.roll_dice(entities[turn].dice_values, entities[turn].dice_color_values)

func spawn_wave():
	for i in budget:
		var ent: Entity = ent_preload.instantiate()
		ent.dice_values = [[0,1,2,3,4,5],[2,2,3,4,5,6]]
		ent.dice_color_values = [Color.RED, Color.BLACK]
		$Players/EnemiesPlacement.add_child(ent)
		ent.global_position.x += 75*i
		ent.selected.connect(_on_player_selected)
		entities.append(ent)


func _on_player_selected(node: Entity) -> void:
	if(selected != null):
		selected.get_node("Selected").hide()
	selected = node
	selected.get_node("Selected").show()


func _on_roll_pressed() -> void:
	dice_spawner.roll_dice([[0,1,2,3,4,5],[9,9,9,9,9,9]], [Color.BLUE,Color.BLACK])
