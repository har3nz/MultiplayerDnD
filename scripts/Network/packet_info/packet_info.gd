class_name PacketInfo

enum PACKET_TYPE {
    ID_ASSIGNMENT = 0,
    PLAYER_POSITION = 1,
    PEER_LIST = 2,
    START_GAME = 3,
    SPAWN_PLAYER = 4,
    SPAWN_SKILL = 5,
    SKILL_POSITION = 6
}

var packet_type: PACKET_TYPE
var flag: int

func encode() -> PackedByteArray:
    var data: PackedByteArray
    data.resize(1)
    data.encode_u8(0, packet_type)
    return data

func decode(data: PackedByteArray) -> void:
    packet_type = data.decode_u8(0)

func send(target: ENetPacketPeer) -> void:
    target.send(0, encode(), flag)

func broadcast(server: ENetConnection) -> void:
    server.broadcast(0, encode(), flag)