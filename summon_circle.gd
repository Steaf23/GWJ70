extends AnimatedSprite2D


func _ready() -> void:
	SoundManager.play_random_sfx(Sounds.SPELL)

func _on_animation_finished() -> void:
	queue_free()
