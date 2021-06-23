extends AudioStreamPlayer2D


func play_with_random_pitch():
	var pitch = rand_range(0.5, 2)
	if !playing:
		self.pitch_scale = pitch
		self.play()
	else:
		var asp = self.duplicate()
		
		get_parent().add_child(asp)
		
		asp.stream = stream
		asp.pitch_scale = pitch
		asp.play()
		
		yield(asp, "finished")
		
		asp.queue_free()
