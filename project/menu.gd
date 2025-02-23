extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scene/Game.tscn"))
