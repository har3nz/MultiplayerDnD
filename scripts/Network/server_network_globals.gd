extends Node

signal handle_player_position(peer_id: int, player_position: PlayerPosition)
signal handle_skill_position(position: PlayerPosition, rotation: float)

var peer_ids: Array[int]

func _ready() -> void:
    NetworkHandler.on_peer_connected.connect(on_peer_connected)
    NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
    NetworkHandler.on_server_packet.connect(on_server_packet)

func on_peer_connected(peer_id: int) -> void:
    peer_ids.append(peer_id)
    
    IDAssignment.create(peer_id, peer_ids).broadcast(NetworkHandler.connection)


func on_peer_disconnected(peer_id: int) -> void:
    peer_ids.erase(peer_id)

    #Create IDUnassigment to broadcast to all still connected peers


func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
    var packet_type: int = data.decode_u8(0)
    match packet_type:
        PacketInfo.PACKET_TYPE.PLAYER_POSITION:
            handle_player_position.emit(peer_id, PlayerPosition.create_from_data(data))
        PacketInfo.PACKET_TYPE.SKILL_POSITION:
            handle_skill_position.emit(SkillPosition.create_from_data(data))
        _:
            push_error("Packet type with index ", data [0], " unhandled!")






