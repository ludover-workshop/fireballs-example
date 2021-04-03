extends KinematicBody2D

signal spawn_fireball

export(float) var speed = 500

onready var FireballScene = preload("res://Fireball/Fireball.tscn")
onready var main_node = get_tree().get_current_scene()

func move_with_keyboard(delta):
	var input_vector = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	
	input_vector = input_vector.normalized()
	
	move_and_slide(input_vector * speed)

func update_target(delta):
	var target_position = get_viewport().get_mouse_position()
	rotation = target_position.angle_to_point(self.position)
	
func check_fire_input(delta):
	if Input.is_action_just_pressed("fire"):
		var fireball = FireballScene.instance()
		fireball.position = self.position
		fireball.direction = Vector2(1, 0).rotated(self.rotation)
		main_node.add_child(fireball)

func _physics_process(delta):
	update_target(delta)
	move_with_keyboard(delta)
	check_fire_input(delta)
	
	
	
