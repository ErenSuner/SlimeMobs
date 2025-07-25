extends State
class_name AttackState

@onready var hitbox: Area2D = %HitBoxArea

func enter(payload: Dictionary = {}) -> void:
	player.current_state = PlayerGlobal.States.ATTACK
	player.velocity = Vector2.ZERO
	
	player.play_animation(player.current_slime_form, PlayerGlobal.States.ATTACK, player.current_direction)
	player.animated_sprite.animation_finished.connect(_on_animation_finished)
	
	hitbox.monitoring = true
	hitbox.get_node("CollisionShape2D").disabled = false


func exit() -> void:
	if player.animated_sprite.is_connected("animation_finished", _on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)
	
	hitbox.monitoring = false
	hitbox.get_node("CollisionShape2D").disabled = true


func _on_animation_finished():
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		state_machine.transition_to("Move")
	else:
		state_machine.transition_to("Idle")
