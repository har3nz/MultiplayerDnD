class_name StartGame
extends PacketInfo

static func create() -> StartGame:
	var info := StartGame.new()
	info.packet_type = PACKET_TYPE.START_GAME
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	return info

static func create_from_data(data: PackedByteArray) -> StartGame:
	var info := StartGame.new()
	info.decode(data)
	return info
