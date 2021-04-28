extends Node2D

export(float) var speed = 1000

export(float) var timeToLive = 1

export(bool) var destroy_on_hit = true

signal hit(body)

func init(global_position: Vector2, rotation: float):
	get_parent().global_position = global_position
	get_parent().rotation = rotation

func _physics_process(delta):
	timeToLive -= delta
	if(timeToLive <= 0):
		destroy()
	get_parent().move_local_x(speed * delta)

func destroy():
	if get_parent().has_method("destroy"):
		self.queue_free()
		get_parent().destroy()
	else:
		get_parent().queue_free()

func _on_Area2D_body_entered(body):
	emit_signal("hit", body)
	
	if destroy_on_hit:
		destroy()
