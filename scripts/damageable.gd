tool
class_name Damageable
extends Node

export(float) var health = 100

export(NodePath) var knockback_handler_path
export(NodePath) var blinking_sprite_path

onready var knockback_handler = get_node(knockback_handler_path)
onready var blinking_sprite = get_node(blinking_sprite_path)

signal killed(killer)

func _get_configuration_warning():
	if !blinking_sprite_path:
		return "A blinker sprite is needed"
	return ""

func receive_damage_from(damager):
	if knockback_handler: knockback_handler.knockback_from(damager.position, damager.knockback_strength) 
	health -= damager.damage
	if health <= 0:
		be_killed_by(damager)
	start_blinking()
	
func be_killed_by(damager):
	emit_signal("killed", damager)
	get_parent().queue_free()	
	
func start_blinking():
	$BlinkingTimer.start()
	blinking_sprite.material.set_shader_param('blink_intensity', 1)
	
func _on_BlinkingTimer_timeout():
	blinking_sprite.material.set_shader_param('blink_intensity', 0)
