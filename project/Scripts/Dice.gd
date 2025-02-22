extends RigidBody3D

@export var random_fling_force: float = 50

var sides

@onready var cube: MeshInstance3D = $Cube
var cur_side = null

func _ready() -> void:
	apply_force(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized()*random_fling_force*5)
	apply_torque(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized()*random_fling_force/5)

func init(die_sides, color: Color):
	sides = die_sides
	for i in range(len(die_sides)):
		var side_sprite: AnimatedSprite3D = get_node("Faces/"+str(i))
		side_sprite.frame = die_sides[i]
	cube.material_override = cube.get_active_material(0).duplicate()
	cube.material_override.albedo_color = color
	global_position = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))

func get_current_value():
	var highest_y_axis = -INF
	for i: Node3D in get_node("Faces").get_children():
		if(i.global_position.y > highest_y_axis):
			cur_side = sides[int(str(i.name))]
			highest_y_axis = i.global_position.y
	return cur_side
