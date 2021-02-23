class_name Demon
extends KinematicBody2D

export(float) var health = 100
export(float) var rotation_speed = PI * 0.4

export(float) var damage = 10
export(float) var knockback_strength = 1500

export(float) var attack_cooldown = 1
var remaining_attack_cooldown = 0

var target: Node2D
var attacking: bool = false

onready var targetVelocityBehaviour = $TargetVelocityBehaviour
onready var animationPlayer = $AnimationPlayer
onready var demonSprite = $demonSprite
onready var blinkingTimer = $BlinkingTimer
	
func init(target, global_position):
	self.target = target
	self.global_position = global_position
	self.rotation = angle_to_target()
	
func angle_to_target():
	return (target.position - self.position).angle() if is_instance_valid(target) else rand_range(0, TAU)

func receive_damage_from(damager):
	targetVelocityBehaviour.knockback_from(damager.position, damager.knockback_strength)
	health -= damager.damage
	if health <= 0:
		be_killed_by(damager)
	start_blinking()

func start_blinking():
	blinkingTimer.start()
	demonSprite.material.set_shader_param('blink_intensity', 1)

func _on_BlinkingTimer_timeout():
	demonSprite.material.set_shader_param('blink_intensity', 0)
		
func be_killed_by(damager):
	damager.killed(self)
	queue_free()
	
func _process(delta):
	if is_instance_valid(target):
		turn_towards_target(delta)
	
	if attacking && remaining_attack_cooldown <= 0:
		attack_all(attack_area.get_overlapping_bodies())
		remaining_attack_cooldown = attack_cooldown
	else:
		remaining_attack_cooldown = max(remaining_attack_cooldown - delta, 0)
		
func turn_towards_target(delta):
	var target_angle = angle_to_target()
	
	# We normalize the angle in the case where the count goes from PI to -PI
	if sign(target_angle) != sign(rotation) && abs(target_angle) > PI / 2:
		target_angle = target_angle + TAU * sign(rotation)
	
	var to_target = target_angle - rotation
	
	var max_rotation = rotation_speed * delta if abs(to_target) < PI / 4 else rotation_speed * delta * 4

	rotate(sign(to_target) * min(abs(to_target), max_rotation))
	
	
	var front = Vector2.RIGHT.rotated(rotation)
	
	targetVelocityBehaviour.target_direction = front
	animationPlayer.playback_speed = targetVelocityBehaviour.velocity.length() / targetVelocityBehaviour.max_speed


func attack_all(bodies):
	for body in bodies:
		if body.has_method("receive_damage_from"):
			body.receive_damage_from(self)

func _on_AttackArea_body_entered(body):
	attacking = true

onready var attack_area = $AttackArea

func _on_AttackArea_body_exited(body):
	if attack_area.get_overlapping_bodies().empty():
		attacking = false 
