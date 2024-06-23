extends Camera2D

func _ready() -> void:
	limit_left = $Node/TL.global_position.x
	limit_top = $Node/TL.global_position.y
	limit_right = $Node/BR.global_position.x
	limit_bottom = $Node/BR.global_position.y


func move_left_limit(target: int, time_seconds: float) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "limit_left", target, time_seconds)

func move_right_limit(target: int, time_seconds: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "limit_right", target, time_seconds)
