class_name PlayerPosition extends PacketInfo

var id: int
var position: Vector2

static func create(id: int, position: Vector2) -> PlayerPosition:
	var info: PlayerPosition = PlayerPosition.new()
	info.packet_type = PACKET_TYPE.PLAYER_POSITION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id
	info.position = position
	return info

static func create_from_data(data: PackedByteArray) -> PlayerPosition:
	var info: PlayerPosition = PlayerPosition.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(10)