extends CharacterBody2D

@onready var state_machine: Node = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D
@onready var hurt_box_area: Area2D = %HurtBoxArea
@onready var hit_box_area: Area2D = %HitBoxArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_cooldown_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var slime_form_component: Node = $SlimeFormComponent


var current_state: PlayerGlobal.States = PlayerGlobal.States.IDLE
var current_direction: PlayerGlobal.Direction = PlayerGlobal.Direction.DOWN
var current_slime_form: PlayerGlobal.SlimeForm = PlayerGlobal.SlimeForm.GREEN

var can_take_damage: bool = true


func _ready() -> void:
	position = get_viewport_rect().size / 2
	
	damage_cooldown_timer.timeout.connect(on_damage_cooldown_timer_timeout)
	health_component.died.connect(_on_died)


func _physics_process(delta: float) -> void:
	check_for_damage()
	check_for_form_change()



func check_for_damage():
	var overlapping_bodies = hurt_box_area.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		if can_take_damage:
			can_take_damage = false
			
			health_component.take_damage(10)
			damage_cooldown_timer.start()
			state_machine.transition_to("Hurt")


func check_for_form_change():
	if Input.is_action_just_pressed("change_form"):
		slime_form_component.current_form_to_next()
		play_animation(current_slime_form, current_state, current_direction)
		health_bar.change_health_bar_theme(PlayerGlobal.SLIME_FORMS[current_slime_form]["fill_color"], PlayerGlobal.SLIME_FORMS[current_slime_form]["bg_color"])



func play_animation(form: PlayerGlobal.SlimeForm, state: PlayerGlobal.States, direction: PlayerGlobal.Direction):
	var animation_name = PlayerGlobal.SLIME_FORMS[form]["name"] + "_" + PlayerGlobal.STATE_NAMES[state] + "_" + PlayerGlobal.DIRECTION_NAMES[direction]
	animated_sprite.play(animation_name)


func _on_died() -> void:
	state_machine.transition_to("Dead")


func on_damage_cooldown_timer_timeout():
	can_take_damage = true


func _on_hit_box_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		if area.owner.has_method("take_damage"):
			area.owner.take_damage(10)
