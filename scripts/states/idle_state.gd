extends State
class_name IdleState

func enter(payload: Dictionary= {}) -> void:
	player.current_state = PlayerGlobal.States.IDLE
	
	player.velocity = Vector2.ZERO
	player.play_animation(player.current_slime_form, PlayerGlobal.States.IDLE, player.current_direction)


func physics_update(_delta: float) -> void:
	# Idle durumundayken her fizik karesinde kontrol edilecekler:
	
	# 1. Saldırı girdisi var mı? Varsa Attack durumuna geç.
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return
	
	# 2. Hareket girdisi var mı? Varsa Move durumuna geç.
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		state_machine.transition_to("Move")
		return
