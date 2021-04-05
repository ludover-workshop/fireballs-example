extends KinematicBody2D

signal spawn_fireball

export(float) var speed = 600

onready var FireballScene = preload("res://Fireball/Fireball.tscn")
onready var main_node = get_tree().get_current_scene()
onready var fireballs_spawn_point = $FireballSpawnPoint

var firing = false

const fireball_cooldown = 1.0 / 5.0
var current_fireball_cooldown = 0

var velocity = Vector2.ZERO
var target_velocity = Vector2.ZERO

var acceleration_amount = 2000
var friction = 1000

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
	
	target_velocity = input_vector * speed

func update_target(delta):
	var target_position = get_viewport().get_mouse_position()
	rotation = target_position.angle_to_point(self.position)
	
func check_fire_input(delta):
	firing = Input.is_action_pressed("fire")

func spawn_fireball(delta):
	current_fireball_cooldown = max(0, current_fireball_cooldown - delta)
	
	if firing && current_fireball_cooldown <= 0:
		var fireball = FireballScene.instance()
		fireball.position = fireballs_spawn_point.global_position
		fireball.direction = self.rotation
		fireball.add_velocity(self.velocity * 0.2)
		main_node.add_child(fireball)
		current_fireball_cooldown = fireball_cooldown
		
func update_velocity_and_move(delta):
	velocity = velocity.move_toward(target_velocity, (acceleration_amount if target_velocity != Vector2.ZERO else friction) * delta)
	velocity = move_and_slide(velocity)

func _process(delta):
	# Process Inputs
	update_target(delta)
	move_with_keyboard(delta)
	check_fire_input(delta)
	
func _physics_process(delta):
	# Process Action
	spawn_fireball(delta)
	update_velocity_and_move(delta)
	
	
	
	
