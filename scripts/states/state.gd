extends Node
class_name State

@onready var state_machine: Node = get_parent()
@onready var player: CharacterBody2D = get_owner()


# Bu durum aktif olduğunda bir kerelik çalışacak fonksiyon.
func enter(payload: Dictionary = {}) -> void:
	pass


# Bu durumdan çıkıldığında bir kerelik çalışacak fonksiyon.
func exit() -> void:
	pass


# Her frame (kare) çağrılacak. Mantık için kullanılır.
func update(_delta: float) -> void:
	pass


# Her fizik karesinde çağrılacak. Hareket gibi fiziksel işlemler için kullanılır.
func physics_update(_delta: float) -> void:
	pass
