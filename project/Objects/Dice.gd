extends RigidBody3D

@export var random_fling_force: float = 5

var sides

var cur_side = null

func _ready() -> void:
	init([0,1,2,3,4,5])
	apply_force(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized()*random_fling_force)
	apply_torque(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized()*random_fling_force)

func _process(delta: float) -> void:
	print(get_current_value())

func init(die_sides):
	sides = die_sides
	for i in range(len(die_sides)):
		var side_sprite: AnimatedSprite3D = get_node("Faces/"+str(i))
		side_sprite.frame = die_sides[i]

func get_current_value():
	var highest_y_axis = -INF
	for i: Node3D in get_node("Faces").get_children():
		if(i.global_position.y > highest_y_axis):
			cur_side = sides[int(str(i.name))]
			highest_y_axis = i.global_position.y
	return cur_side
