extends Actor

func _ready() -> void:
	%Sword.hide()
	%Sword.disable(true)

@onready var anim = $Sprite2D/AnimationPlayer

var count = 0
var attacking = true
var rightside = true

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if velocity.x < -10.0:
		$Pivot.scale = Vector2(-1, 1)
		#$Sprite2D.scale = Vector2(-1, 1)
		rightside = true
	elif velocity.x > 10.0:
		$Pivot.scale = Vector2(1, 1)
		#$Sprite2D.scale = Vector2(1, 1)
		rightside = false
		
	if attacking:
		count += 1
		if count == 4:
			%Sword.hide()
			%Sword.disable(true)
			count = 0
			attacking = false


func _input(event: InputEvent) -> void:
	if %Sword.is_disabled() and event.is_action_pressed("normal_attack"):
		%Sword.show()
		%Sword.disable(false)
		attacking = true



func _on_attack_timer_timeout() -> void:
	pass
