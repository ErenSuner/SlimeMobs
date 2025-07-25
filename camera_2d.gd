extends Camera2D

var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Forces this Camera2D to become the current active one.
	make_current() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acquire_target()
	
	# cameranın karakterin biraz gerisinden smooth gelmesi için target postion ile arasına mesafe ekliyoruz
	# bunun frame indipendant yani her fps seviyesinde aynı hissiyatı vermesi için küçük bi matematik yapıyoruz
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func acquire_target():
	# oluşturulan "player" grubundaki her nodeu getirir
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		# bu listede o gruptaki her türlü node olduğu için 
		# godot bunun hangi tür olduğunu bilmiyor, bu yüzden .property öneremiyor 
		# ve error almaya yatkınlığı arttırır bence o yüzden "as Node2D" kullandık
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
