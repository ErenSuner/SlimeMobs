extends CharacterBody2D

enum State { IDLE, WALK, RUN, ATTACK}
enum Direction { DOWN, UP, LEFT, RIGHT }
enum SlimeForm { GREEN, DEAD, LAVA}

const STATE_NAMES = {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.RUN: "run",
	State.ATTACK: "attack"
}

const DIRECTION_NAMES = {
	Direction.DOWN: "down",
	Direction.UP: "up",
	Direction.LEFT: "left",
	Direction.RIGHT: "right"
}

const SLIME_FORMS = {
	SlimeForm.GREEN: {
		"name": "slime1",
		"fill_color": Color("63c99f"),
		"bg_color": Color("264547")
		},
	SlimeForm.DEAD: {
		"name": "slime2",
		"fill_color": Color("88c6ff"),
		"bg_color": Color("413b69")
		},
	SlimeForm.LAVA: {
		"name": "slime3",
		"fill_color": Color("eeb53f"),
		"bg_color": Color("41302f")
		}
}

const SLIME_FORMS_ARRAY = [SlimeForm.GREEN, SlimeForm.DEAD, SlimeForm.LAVA]


@export var WALK_SPEED = 100
@export var RUN_SPEED = 175

@onready var animated_sprite: AnimatedSprite2D = $Sprite2D
@onready var hurt_box_area: Area2D = $HurtBoxArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_cooldown_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar

var speed_modifier: float = 1.0

var current_state: State = State.IDLE
var current_direction: Direction = Direction.DOWN
var current_slime_form: SlimeForm = SlimeForm.GREEN

var is_attacking: bool = false
var can_take_damage: bool = true


func _ready() -> void:
	position = get_viewport_rect().size / 2
	play_animation(SlimeForm.GREEN, State.IDLE, Direction.DOWN)
	
	animated_sprite.animation_finished.connect(on_attack_finished)
	
	damage_cooldown_timer.timeout.connect(on_damage_cooldown_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	health_component.died.connect(func(): health_component.reset_health())



func _physics_process(delta: float) -> void:
	var is_running = Input.is_action_pressed("sprint")
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
	
	if is_attacking:
		play_animation(current_slime_form, State.ATTACK, current_direction)
		await animated_sprite.animation_finished
		return
	
	if Input.is_action_just_pressed("change_form"):
		current_form_to_next(current_slime_form)
		change_to_next_form()
	
	
	check_for_damage()
	
	# WASD + Shift => RUN, else WALK
	var target_speed = RUN_SPEED if is_running and direction != Vector2.ZERO else WALK_SPEED
	velocity = direction * target_speed * speed_modifier
	move_and_slide()
	update_animation()



func check_for_damage():
	var overlapping_bodies = hurt_box_area.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		speed_modifier = 0.4
		
		if !can_take_damage:
			return
		
		can_take_damage = false
		health_component.take_damage(10)
		damage_cooldown_timer.start()
		print(health_component.health)
	else:
		speed_modifier = 1


func update_animation():
	var new_state: State
	var new_direction: Direction = current_direction
	
	if velocity.length() > 0:
		if velocity.length() >= RUN_SPEED:
			new_state = State.RUN
		else:
			new_state = State.WALK
		
		# Yatay hareket dikey hareketten daha baskınsa yönümüz "side" (yan).
		if abs(velocity.x) >= abs(velocity.y):
			if velocity.x > 0:
				new_direction = Direction.RIGHT
			elif velocity.x < 0:
				new_direction = Direction.LEFT
		
		else: # Dikey hareket daha baskınsa...
			if velocity.y > 0:
				new_direction = Direction.DOWN
			else:
				new_direction = Direction.UP
		
	else:
		new_state = State.IDLE
	
	# Sadece durum veya yön DEĞİŞTİYSE animasyonu güncelle.
	if new_state != current_state or new_direction != current_direction:
		current_state = new_state
		current_direction = new_direction
		play_animation(current_slime_form, new_state, new_direction)


func current_form_to_next(current_form: SlimeForm):
	var current_index = SLIME_FORMS_ARRAY.find(current_form)
	var next_index = (current_index + 1) % SLIME_FORMS_ARRAY.size() # Modulo (%) operatörü, sona gelince başa dönmemizi sağlar.
	current_slime_form = SLIME_FORMS_ARRAY[next_index]
	print("Yeni forma geçildi: ", SlimeForm.keys()[current_slime_form])


func change_to_next_form() -> void:
	play_animation(current_slime_form, current_state, current_direction)
	health_bar.change_health_bar_theme(SLIME_FORMS[current_slime_form]["fill_color"], SLIME_FORMS[current_slime_form]["bg_color"])


func play_animation(form: SlimeForm, state: State, direction: Direction):
	var animation_name = SLIME_FORMS[form]["name"] + "_" + STATE_NAMES[state] + "_" + DIRECTION_NAMES[direction]
	animated_sprite.play(animation_name)


func on_health_changed():
	health_bar.value = health_component.health


func on_attack_finished():
	is_attacking = false
	play_animation(current_slime_form, current_state, current_direction)


func on_damage_cooldown_timer_timeout():
	print("timer timeout oldu")
	can_take_damage = true
