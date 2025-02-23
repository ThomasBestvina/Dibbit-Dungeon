class_name Entity extends Node2D

signal selected(node: Entity)

@export var player: bool = false

@export var max_health: int = 20

@export var health: int = 20

@export var dice_values: Array[Array] = []

@export var dice_color_values: Array[Color] = []

@export var items: Array = []

@onready var potion_pre = preload("res://Objects/PotionPanel.tscn")

var taking_damage: bool
@export var damage_flash_times: float = 0.1

@onready var hit_text = preload("res://Objects/HitScore.tscn")

func _ready() -> void:
	$Selected.play()
	$HealthText.text = "[center]"+str(health)
	$HealthBar.value = float(health)/max_health*100
	$Entity.play()
	$heartCard.play()
	$Horse.play()

func _process(_delta: float) -> void:
	if taking_damage:
		$Entity.play("hit")
		$heartCard.play("hit")
		$Horse.play("hit")

func init():
	if player: return
	if max_health > 30*len(dice_values):
		$Entity.hide()
		$Horse.hide()
		$heartCard.show()
	elif max_health < 10*len(dice_values):
		$Entity.show()
		$Horse.hide()
		$heartCard.hide()
	else:
		$Entity.hide()
		$Horse.show()
		$heartCard.hide()

func remove_health(val: int):
	if(health == max_health && val >= max_health*2):
		var ob = preload("res://Objects/Obliterated.tscn").instantiate()
		PlayerResources.camera.add_child(ob)
	health -= val
	health = min(max_health, health)
	$HealthText.text = "[center]"+str(health)
	$HealthBar.value = float(health)/max_health*100
	if(val > 0):
		var damage_amount = hit_text.instantiate()
		PlayerResources.camera.get_parent().add_child(damage_amount)
		damage_amount.text = "[color=ff3300]" + str(val)
		damage_amount.scale =  Vector2.ONE*min(max(0.5,(-val)/(max_health/2)*1.5 ),3)
		damage_amount.position = global_position+ Vector2(randi_range(0,41),-randi_range(0,63))
		taking_damage = true
		$HitPlayer.play()
		begin_toggle()
		$TakingDamage.start(0.75)
		PlayerResources.camera.start_shake(5.0,0.5)
	if(val < 0):
		var heal_amount = hit_text.instantiate()
		PlayerResources.camera.get_parent().add_child(heal_amount)
		heal_amount.text = "[color=33cc33]" + str(-val)
		heal_amount.scale =  Vector2.ONE*min(max(0.5,(-val)/(max_health/2)*1.5 ),3)
		heal_amount.position = global_position+ Vector2(randi_range(0,41),-randi_range(0,63))
		$HealPlayer.play()

func attack():
	$heartCard.play("attack")
	$Horse.play("attack")
	$Entity.play("attack")

func begin_toggle():
	while(taking_damage):
		await get_tree().create_timer(damage_flash_times).timeout
		if(!taking_damage): return
		$Entity.modulate = toggle_color($Entity.modulate)
		$heartCard.modulate = toggle_color($heartCard.modulate)
		$Horse.modulate = toggle_color($Horse.modulate)


func toggle_color(color: Color) -> Color:
	if color == Color(1, 1, 1):  # White
		return Color(1, 0, 0)  # Red
	elif color == Color(1, 0, 0):  # Red
		return Color(1, 1, 1)  # White
	return color  # Return the same color if it's neither red nor white


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && !player:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("selected",self)

func add_potion(id):
	var potion = potion_pre.instantiate()
	$Potions.add_child(potion)
	potion.id = id
	potion.modulate = Lookup.potion_color_lookup(id)


func _on_horse_animation_finished() -> void:
	$Horse.play("default")

func _on_heart_card_animation_finished() -> void:
	$heartCard.play("default")


func _on_entity_animation_finished() -> void:
	$Entity.play("default")


func _on_taking_damage_timeout() -> void:
	taking_damage = false
	$Entity.modulate = Color.WHITE
	$heartCard.modulate = Color.WHITE
	$Horse.modulate = Color.WHITE
	$Entity.play("default")
	$heartCard.play("default")
	$Horse.play("default")
