class_name Mage
extends KinematicBody2D

const fireball_scene := preload("res://scenes/fireball.tscn")
const meteor_scene := preload("res://scenes/meteor.tscn")
onready var fireball_spawn_point = $FireballSpawnPoint

export(float) var fire_cooldown = 0.2
export(float) var meteor_cooldown = 3
var remaining_fire_cooldown = 0
var remaining_meteor_cooldown = 0

var kill_count = 0

signal mage_damaged

onready var targetVelocityBehaviour = $TargetVelocityBehaviour
onready var mage_sprite = $mage
onready var fireballs_parent = get_fireballs_parent()

func get_fireballs_parent():
	var node = get_tree().get_current_scene().find_node('Fireballs')
	return node if node else get_tree().get_current_scene()

func _physics_process(delta):
	move_using_keyboard(delta)

func _process(delta):
	update_target(delta)
	check_fireball_trigger(delta)
	check_meteor_trigger(delta)

func check_projectile_trigger(delta, action: String, remainingCooldownRef: String, cooldown: float, instancer: PackedScene):
	var currentCooldown = get(remainingCooldownRef)
	if Input.is_action_pressed(action) && currentCooldown <= 0:
		var projectile = instancer.instance()
		projectile.init(self, fireball_spawn_point.global_position, self.rotation)
		fireballs_parent.add_child(projectile)
		
		set(remainingCooldownRef, cooldown)
	else: 
		set(remainingCooldownRef, max(currentCooldown - delta, 0))

func check_meteor_trigger(delta):
	check_projectile_trigger(delta, "ui_fire_meteor", "remaining_meteor_cooldown", meteor_cooldown, meteor_scene)
		
	
func check_fireball_trigger(delta):
	check_projectile_trigger(delta, "ui_fire", "remaining_fire_cooldown", fire_cooldown, fireball_scene)
	
func update_target(delta):
	rotation = get_viewport().get_mouse_position().angle_to_point(position)
	
func move_using_keyboard(delta):
	var input_vector = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	
	input_vector = input_vector.normalized()
	
	targetVelocityBehaviour.target_direction = input_vector
	
func killed(body):
	kill_count += 1
	print("Kill count: " + str(kill_count))

onready var damageable = $Damageable

func receive_damage_from(damager):
	damageable.receive_damage_from(damager)
	emit_signal("mage_damaged")
