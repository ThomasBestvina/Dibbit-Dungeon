class_name Entity extends Node2D

signal selected(node: Entity)

@export var player: bool = false

@export var max_health: int = 20

@export var health: int = 20

@export var dice_values: Array[Array] = []

@export var dice_color_values: Array[Color] = []

@export var items: Array = []

func _ready() -> void:
	$Selected.play()
	$HealthText.text = "[center]"+str(health)
	$HealthBar.value = float(health)/max_health*100
	if(player):
		$Entity.play("idle_combat")

func remove_health(val: int):
	health -= val
	health = min(max_health, health)
	$HealthText.text = "[center]"+str(health)
	$HealthBar.value = float(health)/max_health*100


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && !player:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("selected",self)
