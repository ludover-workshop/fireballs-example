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
		demons.add_child(demon)
