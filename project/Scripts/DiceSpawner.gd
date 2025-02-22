class_name spawner extends Node3D

signal die_finished(values: Array)

var dice = []

var can_check: bool = false

@onready var die_obj = preload("res://Objects/Dice.tscn")

## List of die is a 2d array!!
func roll_dice(list_of_die, list_of_die_color):
	for new_die in len(list_of_die):
		var die = die_obj.instantiate()
		add_child(die)
		die.init(list_of_die[new_die], list_of_die_color[new_die])
		dice.append(die)
		can_check = false
		$Timer.start(3)

func _process(_delta: float) -> void:
	if(len(dice) == 0 || !can_check): return
	var can_die: bool = true
	var values = []
	for die: RigidBody3D in dice:
		if(die.linear_velocity.length() > 0.05):
			can_die = false
		else:
			values.append(die.get_current_value())
	if(can_die):
		for die in dice.duplicate():
			die.queue_free()
		dice = []
		emit_signal("die_finished", values)

func get_cur_values() -> Array:
	var values: Array = []
	for die: RigidBody3D in dice:
		values.append(die.get_current_value())
	return values
func _on_timer_timeout() -> void:
	can_check = true
