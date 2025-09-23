extends MultiplayerSpawner


@export var network_player: PackedScene = preload("res://scenes/player.tscn")
@export var wizard: PackedScene = preload("res://scenes/wizard.tscn")

@export var fireball: PackedScene = preload("res://scenes/fireball.tscn")
@export var mini_missile: PackedScene = preload("res://scenes/mini_missile.tscn")

func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	var player: Node
	if ClassHandler.players[id] == "wizard":
		player = wizard.instantiate()
	else:
		player = network_player.instantiate()
	player.name = str(id)
	player.position = Vector2(300,300)

	get_parent().call_deferred("add_child", player)


@rpc("any_peer", "call_remote", "reliable")
func sv_spawn_fireball() -> void:
	if !multiplayer.is_server(): return

	get_parent().call_deferred("add_child", fireball)



@rpc("any_peer", "call_remote", "reliable")
func sv_spawn_mini_missile() -> void:
	if !multiplayer.is_server(): return

	get_parent().call_deferred("add_child", mini_missile)