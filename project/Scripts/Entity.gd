class_name Entity extends Node2D

signal selected(node: Entity)

@export var player: bool = false

@export var max_health: int = 20

@export var health: int = 20

@export var dice_values: Array[Array] = []

@export var dice_color_values: Array[Color] = []

@export var items: Array = []

@onready var potion_pre = preload("res://Objects/PotionPanel.tscn")



func _ready() -> void:
	$Selected.play()
	$HealthText.text = "[center]"+str(health)
	$HealthBar.value = float(health)/max_health*100
	if(player):
		$Entity.play("idle_combat")

func remove_health(val: int):
	if(health == max_health && val >= max_health*2):
		var ob = preload("res://Objects/Obliterated.tscn").instantiate()
		PlayerResources.camera.add_child(ob)
	health -= val
	health = min(max_health, health)
	$HealthText.text = "[center]"+str(health)
	$HealthBar.value = float(health)/max_health*100
	if(val > 0):
		$HitPlayer.play()
		PlayerResources.camera.start_shake(5.0,0.5)
	if(val < 0):
		$HealPlayer.play()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && !player:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("selected",self)

func add_potion(id):
	var potion = potion_pre.instantiate()
	$Potions.add_child(potion)
	potion.id = id
	print(potion.id)
	potion.modulate = Lookup.potion_color_lookup(id)
