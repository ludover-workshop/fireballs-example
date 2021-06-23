extends Node2D

onready var shape = $Area2D/CollisionShape2D

export(float) var explosionRadius = 500
export(float) var time_to_live = 0.5

var elapsed: float = 0.0

export(float) var damage = 50
export(float) var knockback_strength = 880

export(float) var min_radius = 20

var owner_mage

func _ready():
	var circle = CircleShape2D.new()
	circle.radius = min_radius
	shape.shape = circle
	
	CameraShaker.shake_camera(get_tree(), 20)
	$Fire.emitting = true
	$Smoke.emitting = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hurting:
		shape.shape.radius = min_radius + ease(elapsed / time_to_live, 1) * (explosionRadius - min_radius)
		update()

var hurting = true

func _process(delta):
	elapsed = min(elapsed + delta, time_to_live)
	
	if elapsed >= time_to_live && hurting:
		$Area2D.queue_free()
		hurting = false
		yield(get_tree().create_timer($Smoke.lifetime), "timeout")
		queue_free()


func _on_Area2D_body_entered(body):
	if is_instance_valid(body) && body.has_method("receive_damage_from"):
		body.receive_damage_from(self)
