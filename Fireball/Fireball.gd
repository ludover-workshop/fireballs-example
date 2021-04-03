extends Node2D

export(float) var speed = 600

var direction = Vector2(1, 0)

export(float) var time_to_live = 3

func _physics_process(delta):
	var velocity = direction * speed
	self.position = self.position + velocity * delta
	
func _process(delta):
	time_to_live -= delta
	if time_to_live <= 0:
		self.queue_free()
