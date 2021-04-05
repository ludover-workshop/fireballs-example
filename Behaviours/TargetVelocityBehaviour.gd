class_name TargetVelocityBehaviour
extends Node2D

var velocity = Vector2.ZERO
var target_velocity = Vector2.ZERO

export(float) var acceleration_amount = 500
export(float) var friction = 500


func _ready():
	assert(get_parent() is KinematicBody2D, "ERROR: Target Velocity only works with KinematicBody2D parents")
	
func _physics_process(delta):
	if target_velocity == null:
		return
	
	velocity = velocity.move_toward(target_velocity, (acceleration_amount if target_velocity != Vector2.ZERO else friction) * delta)
	velocity = get_parent().move_and_slide(velocity)
