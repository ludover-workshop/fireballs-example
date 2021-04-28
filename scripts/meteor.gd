extends Node2D

onready var ExplosionScene = preload("res://scenes/explosion.tscn")

var owner_mage

func init(owner_mage, global_position: Vector2, rotation: float):
	self.owner_mage = owner_mage
	$Projectile.init(global_position, rotation)


func _on_Projectile_hit(body):
	var explosion = ExplosionScene.instance()
	explosion.position = global_position
	explosion.owner_mage = owner_mage
	get_parent().add_child(explosion)


func destroy():
	$Particles2D.emitting = false
	yield(get_tree().create_timer($Particles2D.lifetime), "timeout")
	queue_free()
