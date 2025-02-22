extends Control

@onready var roll_button: TextureButton = $BoxContainer/Roll
@onready var items_button: TextureButton = $BoxContainer/Items
@onready var dice_spawner: spawner = $"SubViewport/DiceRoom"

@onready var ent_preload = preload("res://Objects/Entity.tscn")
@onready var enemies_node = $Players/EnemiesPlacement
@onready var potion_button_preload = preload("res://Objects/PotionButton.tscn")

var entities: Array[Entity] = []

var budget = 2

# Turn 0 means players turn.
var turn = 0

var selected: Entity = null

var rooms_picked = false

func _ready() -> void:
	randomize()
	entities.append($Players/Player)
	PlayerResources.player = $Players/Player
	$Doors/LeftDoor.disabled = true
	$Doors/RightDoor.disabled = true
	spawn_wave()
	_on_dice_room_die_finished([])

func _process(delta: float) -> void:
	if(turn != 0 || ( turn == 0 && selected == null ) ):
		roll_button.disabled = true
	kill_dead_enemies()
	$MoneyText.text = str(PlayerResources.money)
	if(len(dice_spawner.dice) > 0):
		var vals = dice_spawner.get_cur_values()
		var count = 0
		$DiceMath.text = "[center]0"
		var total = 0
		for i in vals:
			$DiceMath.text += "[color=" + dice_spawner.dice[count].mycolor.to_html() + "]"
			$DiceMath.text += Lookup.lookup_operation(i)
			$DiceMath.text += str(Lookup.lookup_realval(i))
			total = Lookup.calculate(total, i)
			count+=1
		$DiceMath.text += "[color=#FFFFFF]=" + str(total)
	if(len(enemies_node.get_children())  == 0 && !rooms_picked && !$Shop.visible):
		## round is over, good job!
		$Doors/LeftDoor.disabled = false
		$Doors/RightDoor.disabled = false
		pick_rooms()
		rooms_picked = true

func pick_rooms():
	if()
	# Pick from 3 rooms, campfire, shop, combat.
	# Only 1 and shop can be selected, any number of combats (well really 2)
	# Lets say 1/3 campfire, 2/5 shop, rest combat.
	var cmpfire: bool = randi_range(1,3) == 3
	var shop: bool = randi_range(1,5) <= 2
	if cmpfire:
		$Doors/LeftDoor.text = "c"
		cmpfire = false
	elif shop:
		$Doors/LeftDoor.text = "s"
		shop = false
	else:
		$Doors/LeftDoor.text = "f"
	
	if shop:
		$Doors/RightDoor.text = "s"
		shop = false
	else:
		$Doors/RightDoor.text = "f"

func _on_dice_room_die_finished(values: Array) -> void:
	if(len(values) == 0): return
	
	var damage: int = 0
	for i in values:
		damage = Lookup.calculate(damage, i)
	if(turn == 0):
		selected.remove_health(damage)
	else:
		entities[0].remove_health(damage)
	kill_dead_enemies()
	turn += 1
	turn = turn % len(entities)
	handle_turn()

func handle_turn():
	if turn == 0: 
		roll_button.disabled = false
		return
	dice_spawner.roll_dice(entities[turn].dice_values, entities[turn].dice_color_values)


func spawn_wave():
	var count: int = 0
	var num_enemies: int = randi_range(1, min(3, budget-1))
	var dice_budget: int = num_enemies 
	var health_budget: int = budget - dice_budget  # The rest goes to health

	# Randomize allocation of the health and dice budgets for variety
	health_budget = randi_range(health_budget / 2, health_budget)  # Randomize health budget allocation
	dice_budget = budget - health_budget  # The remaining budget goes to dice

	while count < num_enemies:
		count += 1
		var ent: Entity = ent_preload.instantiate()
		
		## If count is num enemies, remaining resources go to that
		var health_this_round = randi_range(0,health_budget/(num_enemies-count+1))
		if(count == num_enemies):
			health_this_round = health_budget
		health_budget -= health_this_round
		
		var num_dice = 1 + randi_range(0, dice_budget / (num_enemies-count+1))  
		if(count == num_enemies):
			num_dice = 1+dice_budget
		dice_budget -= num_dice
		for i in range(num_dice):
			var die = Lookup.generate_die()
			ent.dice_values.append(die[0])
			ent.dice_color_values.append(Lookup.make_color_evil(die[1]))

		var health_per_enemy = randi_range(1,4) * (health_this_round) * 6
		ent.max_health = 20 + health_per_enemy  
		ent.health = ent.max_health
		if(budget == 2):
			ent.max_health = min(ent.max_health, 25)
			ent.health = ent.max_health

		$Players/EnemiesPlacement.add_child(ent)
		ent.global_position.x += 75 * count
		ent.selected.connect(_on_player_selected)
		entities.append(ent)

	budget += 1
	budget *= 1.1
	PlayerResources.round += 1


func _on_player_selected(node: Entity) -> void:
	if(selected != null):
		selected.get_node("Selected").hide()
	selected = node
	selected.get_node("Selected").show()
	if(turn == 0):
		roll_button.disabled = false


func _on_roll_pressed() -> void:
	dice_spawner.roll_dice($DiceManager.get_player_die_values(), $DiceManager.get_player_die_colors())
	roll_button.disabled = true

func kill_dead_enemies():
	for i: Entity in entities.duplicate():
		if(i.health <= 0):
			PlayerResources.money += int(i.max_health/10)+len(i.dice_values)
			entities.erase(i)
			i.queue_free()
		

# c = campfire
# s = shop
# f = fight

func manage_room_change(room: String):
	# Were just cheating and changing around some props.
	match room:
		"s":
			$Shop.show()
			$Shop.generate_shop()
			$DiceMath.hide()
			$Doors/LeftDoor.hide()
			$Doors/LeftDoor.disabled = true
			$Doors/RightDoor.text = "f"
			$Campfire.hide()
		"c":
			$Campfire.show()
			$Shop.hide()
			$DiceMath.hide()
			$Doors/LeftDoor.hide()
			$Doors/LeftDoor.disabled = true
			$Doors/RightDoor.text = "f"
		"f":
			$Shop.hide()
			$Doors/LeftDoor.show()
			$DiceMath.show()
			$Doors/LeftDoor.disabled = true
			$Doors/RightDoor.disabled = true
			$Campfire.hide()
			turn = 0
			selected = null
			spawn_wave()
	rooms_picked = false


func _on_left_door_pressed() -> void:
	manage_room_change($Doors/LeftDoor.text)


func _on_right_door_pressed() -> void:
	manage_room_change($Doors/RightDoor.text)


func _on_texture_button_pressed() -> void:
	for i in $PotionList.get_children():
		queue_free()
	for i in PlayerResources.items:
		var but = potion_button_preload.instantiate()
		but.init(i)
		$PotionList.add_child(but)
	$PotionList.show()
	$PotionCancel.show()


func _on_potion_cancel_pressed() -> void:
	$PotionList.hide()
	$PotionCancel.hide()
