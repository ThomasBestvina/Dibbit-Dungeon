#jabreakit jaboughtit!
extends Control

var die_cost = 5

signal bought_die(values, color)

func _ready() -> void:
	generate_shop()

func generate_shop():
	die_cost = int((2+PlayerResources.round)*1.5)
	var die1 = Lookup.generate_die()
	$Buy2/DieRep.values = die1[0]
	$Buy2/DieRep.color = die1[1]
	$Buy2/DieRep.init()
	$Buy2/DieRep.show()
	$Buy2/Cost.text = "[center]" + str(die_cost)
	var die2 = Lookup.generate_die()
	$Buy3/DieRep.values = die2[0]
	$Buy3/DieRep.color = die2[1]
	$Buy3/DieRep.init()
	$Buy3/DieRep.show()
	$Buy3/Cost.text = "[center]" + str(die_cost)
	


func _on_buy_0_pressed() -> void:
	pass # Replace with function body.


func _on_buy_1_pressed() -> void:
	pass # Replace with function body.


func _on_buy_2_pressed() -> void:
	if(PlayerResources.money >= die_cost && $Buy2/DieRep.visible):
		PlayerResources.money -= die_cost
		emit_signal("bought_die", $Buy2/DieRep.values, $Buy2/DieRep.color)
		$Buy2/DieRep.hide()


func _on_buy_3_pressed() -> void:
	if(PlayerResources.money >= die_cost && $Buy3/DieRep.visible):
		PlayerResources.money -= die_cost
		emit_signal("bought_die", $Buy3/DieRep.values, $Buy3/DieRep.color)
		$Buy3/DieRep.hide()
