extends State
class_name DeadState


func enter(payload: Dictionary = {}) -> void:
	player.current_state = PlayerGlobal.States.DEAD
	
	player.play_animation(player.current_slime_form, PlayerGlobal.States.DEAD, player.current_direction)
	player.animated_sprite.animation_finished.connect(_on_animation_finished)


func exit() -> void:
	# State'ten çıkarken timer sinyalinin bağlantısını kes.
	if player.animated_sprite.is_connected("animation_finished", _on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished():
	# Fiziksel çarpışmaları devre dışı bırak.
	player.get_node("CollisionShape2D").disabled = true
	player.get_node("HurtBoxArea/CollisionShape2D").disabled = true
	player.can_take_damage = false

	player.queue_free()
