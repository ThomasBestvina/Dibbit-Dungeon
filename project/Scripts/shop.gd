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
	
	var potion_cost = int((1+PlayerResources.round)*1.2)
	var potion1 = get_random_potion()
	var potion2 = get_random_potion()
	
	$Buy0/Cost.text = "[center]" + str(potion_cost)
	$Buy1/Cost.text = "[center]" + str(potion_cost)
	
	$Buy1/PotionPanel/Sprite2D.modulate = Lookup.potion_color_lookup(potion1)
	$Buy0/PotionPanel/Sprite2D.modulate = Lookup.potion_color_lookup(potion2)
	
	$Buy1/Description.text = Lookup.potion_description_lookup(potion1)
	$Buy0/Description.text = Lookup.potion_description_lookup(potion2)
	$Buy1/PotionPanel.id = potion1
	$Buy0/PotionPanel.id = potion2

func get_random_potion():
	var lst = ["heal","healroll","modroll","defend","reroll"]
	return lst[randi() % len(lst)]

func _on_buy_0_pressed() -> void:
	if(PlayerResources.money >= die_cost && $Buy0/PotionPanel.visible):
		PlayerResources.money -= die_cost
		PlayerResources.items.append($Buy0/PotionPanel.id)
		$Buy0/PotionPanel.hide()



func _on_buy_1_pressed() -> void:
	if(PlayerResources.money >= die_cost && $Buy1/PotionPanel.visible):
		PlayerResources.money -= die_cost
		PlayerResources.items.append($Buy1/PotionPanel.id)
		$Buy1/PotionPanel.hide()


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
