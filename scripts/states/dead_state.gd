extends State
class_name DeadState


func enter(payload: Dictionary = {}) -> void:
	player.current_state = PlayerGlobal.States.DEAD
	
	player.play_animation(player.current_slime_form, PlayerGlobal.States.DEAD, player.current_direction)
	
	# Fiziksel çarpışmaları devre dışı bırak.
	player.get_node("CollisionShape2D").disabled = true
	player.get_node("HurtBoxArea/CollisionShape2D").disabled = true
	player.can_take_damage = false
