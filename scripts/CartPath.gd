tool
extends Path2D

export(Array, Resource) var steps setget set_steps

export(float, 0, 1) var cart_offset = 0 setget set_cart_offset, get_cart_offset

func _ready():
	if not Engine.is_editor_hint():
		print(steps)

func set_steps(value):
	steps.resize(value.size())
	steps = value
	for i in steps.size():
		if not steps[i]:
			var step = CartStep.new()
			step.path_offset = $CartPathFollow2D.unit_offset
			step.resource_name = str(i, "-", CartStep.Action.keys()[step.action], "-", step.path_offset)
			steps[i] = step

func set_cart_offset(value):
	$CartPathFollow2D.unit_offset = value

func get_cart_offset():
	return $CartPathFollow2D.unit_offset
