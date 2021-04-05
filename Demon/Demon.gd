extends KinematicBody2D

export(float) var health = 10

onready var target: Node2D = get_tree().get_current_scene().find_node("Mage")

export(float) var rotation_speed = PI
export(float) var speed = 500

onready var target_velocity_behaviour = $TargetVelocityBehaviour
onready var animation_player = $AnimationPlayer

func receive_damage_from(aFireball):
	health -= aFireball.damage
	
	if health <= 0:
		queue_free()


func front():
	return Vector2.RIGHT.rotated(rotation)

func angle_to_target():
	return front().angle_to(target.position - self.position)

func turn_towards_target(delta):
	if abs(angle_to_target()) > PI / 3:
		rotation_speed = PI
	else:
		rotation_speed = PI * 0.4
	
	if target != null:
		var to_target = angle_to_target()
		
		var rotation_delta = rotation_speed * delta
		
		if abs(rotation_delta) > abs(to_target):
			rotate(to_target)
		else:
			rotate(sign(to_target) * rotation_delta)
		

func _physics_process(delta):
	turn_towards_target(delta)
	
	target_velocity_behaviour.target_velocity = front() * speed
	
	$AnimationPlayer.playback_speed = target_velocity_behaviour.velocity.length() / speed
	
