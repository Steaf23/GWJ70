extends Camera2D

func _ready() -> void:
	limit_left = $Node/TL.global_position.x
	limit_top = $Node/TL.global_position.y
	limit_right = $Node/BR.global_position.x
	limit_bottom = $Node/BR.global_position.y
