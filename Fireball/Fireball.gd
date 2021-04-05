extends Node2D

export(float) var speed = 800

var velocity = Vector2(800, 0)

export(float) var time_to_live = 3

export(float) var damage = 2

var direction setget set_direction, get_direction

func _physics_process(delta):
	self.position = self.position + velocity * delta
	
func set_direction(value):
	velocity = velocity.rotated(value - velocity.angle())
	
func get_direction():
	return velocity.angle()
	
func add_velocity(a_velocity):
	velocity += a_velocity
	
func _process(delta):
	time_to_live -= delta
	if time_to_live <= 0:
		self.queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage_from"):
		body.receive_damage_from(self)
		
	queue_free()
