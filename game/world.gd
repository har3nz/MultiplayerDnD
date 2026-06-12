extends Node2D

var is_authority: bool:
	get: return NetworkHandler.is_server

func _ready():
	if not is_authority:
		return
	
	SpawnPlayer.create(ServerNetworkGlobals.peer_classes).broadcast(NetworkHandler.connection)


	
