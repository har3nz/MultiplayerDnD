extends Node2D

func _ready():
	if multiplayer.is_server():
		for id in multiplayer.get_peers():
			print(id)
			$MultiplayerSpawner.spawn_player(id)
