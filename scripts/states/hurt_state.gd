extends State
class_name HurtState

@onready var move_state: MoveState = %Move
@onready var health_component: HealthComponent = %HealthComponent

func enter(payload: Dictionary = {}) -> void:
	player.current_state = PlayerGlobal.States.HURT
	
	player.velocity = Vector2.ZERO
	player.play_animation(player.current_slime_form, PlayerGlobal.States.HURT, player.current_direction)
	
	player.animated_sprite.animation_finished.connect(_on_animation_finished)



func physics_update(delta:float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		return
	
	var is_running = Input.is_action_pressed("sprint")
	var target_speed = move_state.run_speed if is_running else move_state.walk_speed
	
	player.velocity = direction * target_speed * .45
	player.move_and_slide()


func exit() -> void:
	# State'ten çıkarken timer sinyalinin bağlantısını kes.
	if player.animated_sprite.is_connected("animation_finished", _on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished():
	var direction = Input.get_vector("left", "right", "up", "down")
	if health_component.health <= 0:
		state_machine.transition_to("Dead")
	elif direction != Vector2.ZERO:
		state_machine.transition_to("Move")
	else:
		state_machine.transition_to("Idle")
