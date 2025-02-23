extends Control


func _ready() -> void:
	$AnimatedSprite2D.play()

func _on_button_pressed() -> void:
	PlayerResources.player.max_health *= 1.05
	PlayerResources.player.remove_health(-PlayerResources.player.max_health * 0.3)
	$Button.disabled = true
	## Really fucked solution to get ui to update.



func _on_button_visibility_changed() -> void:
	if(visible):
		$Button.disabled = false
