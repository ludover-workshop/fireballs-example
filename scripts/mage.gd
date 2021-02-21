class_name Mage
extends KinematicBody2D

const fireball_scene = preload("res://scenes/fireball.tscn")
onready var fireball_spawn_point = $FireballSpawnPoint

const FIRE_COOLDOWN = 0.2
var remaining_fire_cooldown = 0

var kill_count = 0

onready var targetVelocityBehaviour = $TargetVelocityBehaviour

func _physics_process(delta):
	move_using_keyboard(delta)
	update_target(delta)
	check_fireball_trigger(delta)
	
func check_fireball_trigger(delta):
	if Input.is_action_pressed("ui_fire") && remaining_fire_cooldown <= 0:
		var fireball = fireball_scene.instance()
		fireball.init(self, fireball_spawn_point.global_position, self.rotation)
		get_tree().get_current_scene().add_child(fireball)
		remaining_fire_cooldown = FIRE_COOLDOWN
		
	remaining_fire_cooldown -= delta	
	
func update_target(delta):
	rotation = get_viewport().get_mouse_position().angle_to_point(position)
	
func move_using_keyboard(delta):
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
	
	targetVelocityBehaviour.target_direction = input_vector
	
func killed(body):
	kill_count += 1
	print("Kill count: " + str(kill_count))
