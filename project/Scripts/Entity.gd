class_name Entity extends Node2D

signal selected(node: Entity)

@export var player: bool = false

@export var max_health: int = 20

@export var health: int = 20

@export var dice_values: Array[Array] = []

@export var dice_color_values: Array[Color] = []

@export var items: Array = []

func _ready() -> void:
	$HealthText.text = health
	$HealthBar.value = health/max_health*100

func remove_health(val: int):
	health -= val
	$HealthText.text = health
	$HealthBar.value = health/max_health*100

func _on_area_2d_mouse_entered() -> void:
	if(!player): return
	emit_signal("selected",self)
