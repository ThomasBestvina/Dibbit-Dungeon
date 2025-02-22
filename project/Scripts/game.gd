extends Control

@onready var dice_spawner: spawner = $"SubViewport/DiceRoom"

var die = []

func _process(delta: float) -> void:
	pass


func _on_dice_room_die_finished(values: Array) -> void:
	print(values)


func _on_roll_button_down() -> void:
	dice_spawner.roll_dice([[0,1,2,3,4,5],[1,2,3,4,5,6]], [Color.BLUE,Color.BLACK])
