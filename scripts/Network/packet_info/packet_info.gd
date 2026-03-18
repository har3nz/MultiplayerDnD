class_name PacketInfo

enum PACKET_TYPE {
	ID_ASSIGNMENT,
	PLAYER_POSITION,
	PEER_LIST,
	START_GAME,
	SPAWN_PLAYER,
	SHOOT_PROJECTILE,
	SKILL_POSITION,
	CLASS_SELECT,
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
