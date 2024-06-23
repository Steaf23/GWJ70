extends Enemy


func play_hit() -> void:
	super.play_hit()
	
	SoundManager.play_random_sfx(Sounds.GOLEM_HURT, 0.8)
