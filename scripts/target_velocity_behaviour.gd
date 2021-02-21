class_name TargetVelocityBehaviour
extends Node

export(float) var max_speed = 400
export(float) var acceleration = 2000
export(float) var friction = 2000

var velocity = Vector2.ZERO
var target_direction = null setget set_target_direction
var target_velocity = null

onready var parent = get_parent()

func set_target_direction(value):
	target_direction = value
	target_velocity = target_direction * max_speed

func _ready():
	assert(get_parent() is KinematicBody2D, "ERROR: Target Velocity only works with KinematicBody2D parents")

func _physics_process(delta):
	if target_velocity == null:
		return
		
	velocity = velocity.move_toward(target_velocity, delta * (acceleration if target_velocity != Vector2.ZERO else friction))
			
	parent.move_and_slide(velocity, Vector2.ZERO)

func knockback_from(other_position, strength = 100):
	var knocbkack_direction = (parent.position - other_position).normalized()
	velocity += knocbkack_direction * strength
