extends Button

var myid: String

func init(id: String) -> void:
	myid = id
	modulate = Lookup.potion_color_lookup(id)
	text = Lookup.potion_description_lookup(id)

func _on_pressed() -> void:
	PlayerResources.player.add_potion(myid)
	PlayerResources.items.erase(myid)
	queue_free()
