extends Node

var IP_ADDRESS : String = "127.0.0.1"
var PORT: int = 15155

var peer : ENetMultiplayerPeer

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func start_client() -> void:
	IP_ADDRESS = "being-morris.gl.at.ply.gg"
	PORT = 5235
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
