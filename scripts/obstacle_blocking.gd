extends StaticBody2D

signal release_cart

func start_cart_blocking():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rotation", 0, 20, 10)
	tween.start()
	yield(get_tree().create_timer(10), "timeout")
	emit_signal("release_cart")
	queue_free()
	
	
