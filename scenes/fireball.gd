extends Node2D

export(float) var speed = 1000

export(float) var timeToLive = 3

func _physics_process(delta):
	timeToLive -= delta
	if(timeToLive <= 0):
		queue_free()
	move_local_x(speed * delta)
