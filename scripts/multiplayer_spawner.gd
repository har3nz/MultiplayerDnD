extends MultiplayerSpawner

@export var network_player: PackedScene = preload("res://scenes/player.tscn")

func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	player.name = str(id)

	get_parent().call_deferred("add_child", player)
