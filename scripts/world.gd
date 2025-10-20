extends Node2D

var is_authority: bool:
	get: return NetworkHandler.is_server

func _ready():
	if not is_authority:
		return

	var start_packet := SpawnPlayer.create()
	start_packet.broadcast(NetworkHandler.connection)
