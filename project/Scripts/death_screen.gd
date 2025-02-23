extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text ="[center]" + str(PlayerResources.round)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Menu.tscn")


func _on_play_again_pressed() -> void:
	PlayerResources.screenshake = true
	PlayerResources.money= 0
	PlayerResources.items = []
	PlayerResources.round = 0
	PlayerResources.camera = null
	PlayerResources.player = null
	get_tree().reload_current_scene()
