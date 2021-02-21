class_name Demon
extends KinematicBody2D

export(float) var health = 100

export(float) var speed = 200

export(float) var rotation_speed = PI * 0.8

var target: Node2D
	
func init(target, global_position):
	self.target = target
	self.global_position = global_position
	self.rotation = angle_to_target()
	
func angle_to_target():
	return (target.position - self.position).angle()

func receive_damage_from(damager):
	health -= damager.damage
	if health <= 0:
		be_killed_by(damager)
		
func be_killed_by(damager):
	damager.killed(self)
	queue_free()
	
func _process(delta):
	var max_rotation = rotation_speed * delta
	var target_angle = angle_to_target()
	
	# We normalize the angle in the case where the count goes from PI to -PI
	if sign(target_angle) != sign(rotation) && abs(target_angle) > PI / 2:
		target_angle = target_angle + TAU * sign(rotation)
	
	var to_target = target_angle - rotation

	rotate(sign(to_target) * min(abs(to_target), max_rotation))
	
	var front = Vector2.RIGHT.rotated(rotation)
	move_and_slide(front * speed, Vector2.ZERO)
