extends Node

var peer : ENetMultiplayerPeer

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(15155)
	multiplayer.multiplayer_peer = peer

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	#peer.create_client("88.240.176.255", 15155)
	#peer.create_client("brown-museums.gl.at.ply.gg", 59378)
	peer.create_client("localhost", 15155)
	multiplayer.multiplayer_peer = peer
	
