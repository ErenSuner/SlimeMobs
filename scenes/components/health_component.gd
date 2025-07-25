extends Node
class_name HealthComponent

signal health_changed 
signal died

@export var max_health: float = 100.0
@export var health: float:
	set(value):
		health = value
		health_changed.emit()
		
		if health <= 0:
			died.emit()

func _ready() -> void:
	health = max_health

func take_damage(damage_amount: float) -> void:
	print(owner.name + " took " + str(damage_amount) + " damage!")
	health = max(health - damage_amount, 0)


func reset_health() -> void:
	print("Player health reset")
	self.health = 100.0
