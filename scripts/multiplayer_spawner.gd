extends MultiplayerSpawner


@export var network_player: PackedScene = preload("res://scenes/player.tscn")
@export var wizard: PackedScene = preload("res://scenes/wizard.tscn")

func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	var player: Node
	if ClassHandler.players[id] == "wizard":
		player = wizard.instantiate()
		print("wizard born : ", str(id))
	else:
		player = network_player.instantiate()
	player.name = str(id)

	get_parent().call_deferred("add_child", player)

@rpc("any_peer", "call_remote", "reliable")
func sv_spawn_fireball(fireball) -> void:
	if !multiplayer.is_server(): return

	get_parent().call_deferred("add_child", fireball)

@rpc("any_peer", "call_remote", "reliable")
func sv_spawn_magic_missile(magic_missile) -> void:
	if !multiplayer.is_server(): return

	get_parent().call_deferred("add_child", magic_missile)