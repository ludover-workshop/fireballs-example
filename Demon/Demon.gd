extends KinematicBody2D

export(float) var health = 10

func receive_damage_from(aFireball):
	health -= aFireball.damage
	
	if health <= 0:
		queue_free()
