extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene

@onready var timer: Timer = $Timer


var player: Node2D
var entities_layer: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	await player.ready


func get_spawn_position():

	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var valid: bool = false
	var additional_distance: int = 20
	
	while not valid:
		for i in 4:
			spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
			var additional_check_offset = random_direction * additional_distance
		
			# Checking terrain collision
			var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
			var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
			if result.is_empty():
				valid = true
				break
			else:
				random_direction = random_direction.rotated(deg_to_rad((90)))
		
		additional_distance *= 2
	
	return spawn_position


func _on_timer_timeout() -> void:
	timer.start()
	
	if player == null:
		return
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()
	enemy.z_index = 1
