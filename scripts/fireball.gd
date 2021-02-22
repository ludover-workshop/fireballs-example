extends Node2D
class_name Fireball

export(float) var speed = 1000

export(float) var timeToLive = 1

export(float) var damage = 12.5
export(float) var knockback_strength = 100

var owner_mage

func init(owner_mage, global_position: Vector2, rotation: float):
	self.owner_mage = owner_mage
	self.global_position = global_position
	self.rotation = rotation

func _physics_process(delta):
	timeToLive -= delta
	if(timeToLive <= 0):
		queue_free()
	move_local_x(speed * delta)


func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage_from"):
		body.receive_damage_from(self)
	queue_free()
	
func killed(body):
	owner_mage.killed(body)
		
