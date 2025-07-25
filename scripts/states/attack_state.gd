extends State
class_name AttackState


func enter(payload: Dictionary = {}) -> void:
	player.current_state = PlayerGlobal.States.ATTACK
	
	player.velocity = Vector2.ZERO
	player.play_animation(player.current_slime_form, PlayerGlobal.States.ATTACK, player.current_direction)
	
	player.animated_sprite.animation_finished.connect(_on_animation_finished)


# Bir state'ten çıkarken, o state içinde bağladığın
# sinyallerin bağlantısını kesmek, olası hafıza sızıntılarını ve
# beklenmedik hataları önler.
func exit() -> void:
	if player.animated_sprite.is_connected("animation_finished", _on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)



func _on_animation_finished():
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		state_machine.transition_to("Move")
	else:
		state_machine.transition_to("Idle")
