extends Camera2D

class_name CameraShaker

var duration = 0.5
var strength = 15
var frequency = 30

export (float, EASE) var easing = 2.5

var remainingShake = 0
var phase = Vector2.ZERO

func _physics_process(delta):
	if remainingShake > 0:
		var elapsed = duration - remainingShake
		offset.x = ease(remainingShake / duration, easing) * sin(elapsed * frequency + phase.x) * strength
		offset.y = ease(remainingShake / duration, easing) * sin(elapsed * frequency + phase.y) * strength
		remainingShake = max(remainingShake - delta, 0)
	else:
		offset = Vector2.ZERO

func shake(strength = 15, duration = 0.7, frequency = 20):
	phase = Vector2(rand_range(0, TAU), rand_range(0, TAU))
	self.strength = strength
	self.duration = duration
	self.frequency = frequency
	
	remainingShake = self.duration

static func shake_camera(tree: SceneTree, strength = 15, duration = 0.7, frequency = 20):
	var camera = tree.current_scene.get_node("Camera")
	
	if camera && camera.has_method("shake"):
		camera.shake(strength, duration, frequency)
