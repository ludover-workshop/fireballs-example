extends TextureRect



func _on_Mage_mage_damaged():
	CameraShaker.shake_camera(get_tree(), 15, 0.5)
	self.visible = true
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("ShowFeedback")
