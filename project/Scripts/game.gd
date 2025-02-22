extends Control

@onready var roll_button: Button = $BoxContainer/Roll
@onready var retreat_button: Button = $BoxContainer/Retreat
@onready var items_button: Button = $BoxContainer/Items

@onready var dice_spawner: spawner = $"SubViewport/DiceRoom"

var die = []

var entities: Array[Entity] = []

var selected: Entity = null

func _ready() -> void:
	entities.append($Players/Player)

func _process(delta: float) -> void:
	pass


func _on_dice_room_die_finished(values: Array) -> void:
	print(values)


func _on_roll_button_down() -> void:
	dice_spawner.roll_dice([[0,1,2,3,4,5],[1,2,3,4,5,6]], [Color.BLUE,Color.BLACK])


func _on_player_selected(node: Entity) -> void:
	pass # Replace with function body.
