extends PathFollow2D


var current_step_index = 0

func get_steps() -> Array:
	return get_parent().steps

func _ready():
	start_step(0)

func start_wait(step: CartStep, index: int):
	unit_offset = step.path_offset
	yield (get_tree().create_timer(step.duration), "timeout")
	if(current_step_index == index):
		start_step(index + 1)

func start_move_to(step: CartStep, index: int):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "unit_offset", unit_offset, step.path_offset, step.duration)
	tween.start()
	yield(tween, "tween_all_completed")
	if(current_step_index == index):
		start_step(index + 1)

func start_step(index: int):
	if get_steps().size() > index:
		print(str("Starting step ", index))
		current_step_index = index
		var step: CartStep = get_steps()[index]
		match step.action:
			CartStep.Action.WAIT:
				start_wait(step, index)
			CartStep.Action.MOVE_TO:
				start_move_to(step, index)
			


	
	
