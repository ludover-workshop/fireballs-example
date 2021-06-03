extends Node

class_name CameraShaker

var duration = 0.5
var strength = 15
var frequency = 30

export (float, EASE) var easing = 2.5

export(NodePath) var camera_path = @".."

onready var camera: Camera2D = get_node(camera_path)

var remainingShake = 0
var phase = Vector2.ZERO

func _physics_process(delta):
	if remainingShake > 0:
		var elapsed = duration - remainingShake
		camera.offset.x = ease(remainingShake / duration, easing) * sin(elapsed * frequency + phase.x) * strength
		camera.offset.y = ease(remainingShake / duration, easing) * sin(elapsed * frequency + phase.y) * strength
		remainingShake = max(remainingShake - delta, 0)
	else:
		camera.offset = Vector2.ZERO

func shake(strength = 15, duration = 0.7, frequency = 20):
	phase = Vector2(rand_range(0, TAU), rand_range(0, TAU))
	self.strength = strength
	self.duration = duration
	self.frequency = frequency
	
	remainingShake = self.duration

static func shake_camera(tree: SceneTree, strength = 15, duration = 0.7, frequency = 20):
	var camera_shaker = tree.current_scene.find_node("CameraShaker")
	
	if camera_shaker && camera_shaker.has_method("shake"):
		camera_shaker.shake(strength, duration, frequency)
