extends Node2D

var is_authority: bool:
    get: return NetworkHandler.is_server

func _ready():
    if not is_authority:
        return

    var start_packet := SpawnPlayer.create()
    start_packet.broadcast(NetworkHandler.connection)
    
    for peer_id in ServerNetworkGlobals.peer_ids:
        PlayerSpawner.spawn_player(peer_id)