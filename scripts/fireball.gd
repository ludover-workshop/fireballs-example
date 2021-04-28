extends Node2D

export(float) var damage = 12.5
export(float) var knockback_strength = 100

var owner_mage

func init(owner_mage, global_position: Vector2, rotation: float):
	self.owner_mage = owner_mage
	$Projectile.init(global_position, rotation)


func _on_Projectile_hit(body):
	if body.has_method("receive_damage_from"):
		body.receive_damage_from(self)

func destroy():
	$Particles2D.emitting = false
	yield(get_tree().create_timer($Particles2D.lifetime), "timeout")
	queue_free()
