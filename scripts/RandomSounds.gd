extends AudioStreamPlayer2D

export(Array, AudioStream) var streams

func play_random():
	self.stream = streams[randi() % streams.size()]
	self.stream.loop = false
	self.play()
