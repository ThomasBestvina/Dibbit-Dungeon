extends Control

func _on_on_pressed() -> void:
	$On.position.x -= 80
	$Off.position.x += 80


func _on_off_pressed() -> void:
	$On.position.x += 80
	$Off.position.x -= 80
