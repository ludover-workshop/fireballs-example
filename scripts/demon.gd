class_name Demon
extends KinematicBody2D

export(float) var health = 100
export(float) var rotation_speed = PI * 0.4

export(float) var damage = 10
export(float) var knockback_strength = 700

export(float) var attack_cooldown = 0.7
var remaining_attack_cooldown = 0

const TIME_BETWEEN_GROWLS = 2.5

var target: Node2D
var attacking: bool = false

var growling: bool = false
var can_growl:bool = true

onready var targetVelocityBehaviour = $TargetVelocityBehaviour
onready var animationPlayer = $AnimationPlayer
onready var demonSprite = $demonSprite
onready var blinkingTimer = $BlinkingTimer
onready var hurtAnimationPlayer = $HurtAnimationPlayer
	
func init(_target, global_position):
	self.target = _target
	self.global_position = global_position
	self.rotation = angle_to_target()
	
func angle_to_target():
	return (target.position - self.position).angle() if is_instance_valid(target) else rand_range(0, TAU)

onready var damageable = $Damageable

func receive_damage_from(damager):
	damageable.receive_damage_from(damager)
	hurtAnimationPlayer.stop(true)
	hurtAnimationPlayer.play("Hurt")
	$Sounds/HurtSounds.play_random()
	
func _process(delta):
	if is_instance_valid(target):
		turn_towards_target(delta)
	
	animationPlayer.playback_speed = targetVelocityBehaviour.velocity.length() / targetVelocityBehaviour.max_speed
	
	if attacking && remaining_attack_cooldown <= 0:
		attack_all(attack_area.get_overlapping_bodies())
		remaining_attack_cooldown = attack_cooldown
	else:
		remaining_attack_cooldown = max(remaining_attack_cooldown - delta, 0)
		
	if growling:
		growl()

func growl():
	if can_growl:
		can_growl = false
		$Sounds/GrowlSounds.play_random()
		yield(get_tree().create_timer(TIME_BETWEEN_GROWLS + rand_range(-1, 1)), "timeout")
		can_growl = true
	
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
	

func attack_all(bodies):
	for body in bodies:
		if body.has_method("receive_damage_from"):
			body.receive_damage_from(self)

func _on_AttackArea_body_entered(_body):
	attacking = true

onready var attack_area = $AttackArea

func _on_AttackArea_body_exited(_body):
	if attack_area.get_overlapping_bodies().empty():
		attacking = false 


func _on_PlayGrowlArea_body_entered(body):
	growling = true


func _on_PlayGrowlArea_body_exited(body):
	if $PlayGrowlArea.get_overlapping_bodies().empty():
		growling = false 
