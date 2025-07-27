extends CharacterBody2D

@onready var hitbox_area: Area2D = $HitboxArea
@onready var hurt_box_area: Area2D = $HurtBoxArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_delay: Timer = $DamageDelayTimer
@onready var damage_cooldown_timer: Timer = $DamageCooldownTimer
@onready var velocity_component: Node = $VelocityComponent
@onready var visuals: Node2D = $Visuals

var damage_amount: int = 0

var can_apply_damage: bool = true

func _ready() -> void:
	position = get_viewport_rect().size / 2.5
	
	health_component.died.connect(_on_died)


func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
	_handle_damage_dealing()


func take_damage(amount: int):
	damage_delay.start()
	damage_amount = max(amount, 0)


func _handle_damage_dealing() -> void:
	if not can_apply_damage:
		return
	
	var overlapping_areas = hitbox_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("hurtbox"):
			if area.owner.get_node("HealthComponent").has_method("take_damage"):
				area.owner.get_node("HealthComponent").take_damage(5)
				can_apply_damage=false
				damage_cooldown_timer.start()


func _on_died():
	queue_free()


func _on_damage_delay_timer_timeout() -> void:
	health_component.take_damage(damage_amount)


func _on_damage_cooldown_timer_timeout() -> void:
	can_apply_damage = true
