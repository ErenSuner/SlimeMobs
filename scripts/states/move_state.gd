extends State
class_name MoveState

@export var walk_speed: float = 100.0
@export var run_speed: float = 175.0


func physics_update(delta:float) -> void:
	# 1. GİRDİYİ KONTROL ET VE DURUM GEÇİŞLERİNİ YAP
	# ----------------------------------------------------
	# Saldırı girdisi var mı? Varsa Attack durumuna geç.
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return
	
	# Hareket girdisi var mı? Yoksa Idle durumuna geç.
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return
	
	
	# 2. HAREKETİ UYGULA
	# ----------------------------------------------------
	var is_running = Input.is_action_pressed("sprint")
	var target_speed = run_speed if is_running else walk_speed
	
	player.velocity = direction * target_speed
	player.move_and_slide()
	
	update_animation(player.velocity)


func update_animation(velocity: Vector2):
	var new_state_enum: int
	var new_direction_enum: int
	
	if velocity.length() >= run_speed:
		new_state_enum = PlayerGlobal.States.RUN
	else:
		new_state_enum = PlayerGlobal.States.WALK
	
	if abs(velocity.x) >= abs(velocity.y):
		if velocity.x > 0:
			new_direction_enum = PlayerGlobal.Direction.RIGHT
		else:
			new_direction_enum = PlayerGlobal.Direction.LEFT
	else:
		if velocity.y > 0:
			new_direction_enum = PlayerGlobal.Direction.DOWN
		else:
			new_direction_enum = PlayerGlobal.Direction.UP
	
	# Sadece durum veya yön DEĞİŞTİYSE animasyonu ve mevcut yönü güncelle.
	if new_state_enum != player.current_state or new_direction_enum != player.current_direction:
		player.current_state = new_state_enum
		player.current_direction = new_direction_enum
		player.play_animation(player.current_slime_form, new_state_enum, new_direction_enum)
