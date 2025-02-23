extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scene/Game.tscn"))


func _on_potion_cancel_pressed() -> void:
	$UjamGuide.hide()
	$PotionCancel.hide()
	$UJamCredits.hide()
	$UiClick.play()


func _on_guide_pressed() -> void:
	$UjamGuide.show()
	$PotionCancel.show()
	$UiClick.play()


func _on_credits_pressed() -> void:
	$UJamCredits.show()
	$PotionCancel.show()
	$UiClick.play()


func _on_quit_pressed() -> void:
	get_tree().quit()
