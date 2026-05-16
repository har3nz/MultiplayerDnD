extends Node2D

var is_authority: bool:
	get: return NetworkHandler.is_server

func _ready():
	if not is_authority:
		return
	
	var start_packet := SpawnPlayer.create(ServerNetworkGlobals.peer_classes)
	start_packet.broadcast(NetworkHandler.connection)

	for peer_id in ServerNetworkGlobals.peer_ids:
		var selected_class: int = ServerNetworkGlobals.peer_classes[peer_id]
		PlayerSpawner.spawn_player(peer_id, selected_class)
