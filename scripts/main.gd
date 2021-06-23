extends Node2D

const demon_scene = preload("res://scenes/demon.tscn")

export(int) var max_demons = 10

onready var mage = $Mage
onready var spawn_curve = $SpawnPath.get_curve()

onready var demons = $Demons


func _ready():
	randomize()
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	if demons.get_child_count() < max_demons:
		var parameter = rand_range(0, spawn_curve.get_point_count())
		var position = spawn_curve.interpolatef(parameter)

		var demon: Demon = demon_scene.instance()
		
		demon.init(mage, position)
		demon.get_node("Damageable").connect('killed', self, 'killed', [demon])
		demons.add_child(demon)

func killed(damager, demon):
	if damager.get("owner_mage") == mage:
		mage.killed(demon)

onready var low_pass_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(0, 0)

func _on_Mage_mage_damaged():
	AudioServer.set_bus_effect_enabled(0, 0, true)
	var tween = $LowPassTween
	tween.remove_all()
	tween.interpolate_property(low_pass_effect, "cutoff_hz", 2000, 10000, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	
	AudioServer.set_bus_effect_enabled(0, 0, false)
