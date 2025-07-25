extends CharacterBody2D

@onready var hurt_box_area: Area2D = $HurtBoxArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_delay: Timer = $DamageDelayTimer

var damage_amount: int = 0

func _ready() -> void:
	position = get_viewport_rect().size / 2.5
	
	health_component.died.connect(_on_died)


func take_damage(amount: int):
	damage_delay.start()
	damage_amount = max(amount, 0)


func _on_damage_delay_timer_timeout() -> void:
	health_component.take_damage(damage_amount)


func _on_died():
	queue_free()
