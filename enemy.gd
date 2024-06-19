extends Actor

@onready var block_timer: Timer = $BlockTimer
@onready var anim = $Sprite2D/AnimationPlayer

signal damaged(damage: int, damage_source: Actor)

func take_damage(damage: int, damage_source: Actor) -> void:
	damaged.emit(damage, damage_source)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	$StateStatus.text = $AttackMachine.current_state.name


func _on_block_timer_timeout() -> void:
	$CollisionShape2D.modulate = Color.WHITE


func damage(num) -> void:
	$HealthBar.current_health -= num


func play_animation(animation: StringName) -> void:
	assert(animation in $Sprite2D/AnimationPlayer.get_animation_list())
	$Sprite2D/AnimationPlayer.play(animation)


func play_moving_animation() -> void:
	var vel = controller.desired_velocity
	var animation: StringName = &"walk"

	if vel.length() < 10:
		animation = &"idle"
	
	play_animation(animation) 
	
	if vel.x < -5:
		$Sprite2D.scale = Vector2(-1, 1)
	elif vel.x > 5:
		$Sprite2D.scale = Vector2(1, 1)
