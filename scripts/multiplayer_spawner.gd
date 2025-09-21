extends MultiplayerSpawner

@export var network_player: PackedScene = preload("res://scenes/character_player.tscn")



func init(id: int) -> void:
	spawn_player(id)

func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	player.name = str(id)
	

	get_tree().call_deferred("add_child", player)
