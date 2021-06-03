extends Camera2D

export(NodePath) var target_path = @"../Mage"
export(bool) var follow_mouse = true

onready var target = get_node(target_path)

func _process(delta):
	if is_instance_valid(target):
		position = get_target_position()

func get_target_position():
	if follow_mouse:
		var mouse_position = get_global_mouse_position()
		return lerp(target.global_position, mouse_position, 0.33)
	else: 
		return target.global_position
