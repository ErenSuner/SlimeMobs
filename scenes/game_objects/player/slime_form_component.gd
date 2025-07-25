extends Node

@onready var player: CharacterBody2D = get_owner()
@onready var health_bar: ProgressBar = %HealthBar

const SLIME_FORMS_ARRAY = [PlayerGlobal.SlimeForm.GREEN, PlayerGlobal.SlimeForm.DEAD, PlayerGlobal.SlimeForm.LAVA]

func current_form_to_next():
	var current_index = SLIME_FORMS_ARRAY.find(player.current_slime_form)
	var next_index = (current_index + 1) % SLIME_FORMS_ARRAY.size() # Modulo (%) operatörü, sona gelince başa dönmemizi sağlar.
	player.current_slime_form = SLIME_FORMS_ARRAY[next_index]
