extends Node
class_name HealthComponent

signal health_changed
signal died

@onready var health_bar: ProgressBar = %HealthBar

@export var max_health: float = 100.0
@export var health: float:
	set(value):
		health = value
		health_bar.value = max(health, 0)
		
		health_changed.emit()
		
		if health <= 0:
			died.emit()

func _ready() -> void:
	health = max_health

func take_damage(damage_amount: float) -> void:
	health = max(health - damage_amount, 0)
