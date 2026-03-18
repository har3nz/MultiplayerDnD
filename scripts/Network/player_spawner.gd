extends Node

func spawn_player(id: int, player: Node) -> void:
	player.owner_id = id
	player.name = str(id)
	call_deferred("add_child", player)
