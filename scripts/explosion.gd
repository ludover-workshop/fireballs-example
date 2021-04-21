extends Node2D

onready var shape = $Area2D/CollisionShape2D

export(float) var expansionSpeed = 1000
export(float) var time_to_live = 0.6

export(float) var damage = 50
export(float) var knockback_strength = 2000

var owner_mage

func _ready():
	var circle = CircleShape2D.new()
	circle.radius = 50
	shape.shape = circle
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	shape.shape.radius += delta * expansionSpeed
	update()

func _process(delta):
	time_to_live -= delta
	
	if time_to_live <= 0:
		queue_free()
	
func _draw():
	draw_circle(Vector2.ZERO, shape.shape.radius, Color(1, 1, 0, 0.5))


func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage_from"):
		body.receive_damage_from(self)
