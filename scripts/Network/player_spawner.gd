extends Node

const LOW_LEVEL_NETWORK_PLAYER = preload("res://scenes/Characters/wizard.tscn")

func spawn_player(id: int) -> void:
	if get_node_or_null(str(id)) != null:
		return

	var player = LOW_LEVEL_NETWORK_PLAYER.instantiate()
	player.owner_id = id
	player.name = str(id)
	call_deferred("add_child", player)

