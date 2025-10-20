class_name SpawnPlayer extends PacketInfo

static func create() -> SpawnPlayer:
	var info := SpawnPlayer.new()
	info.packet_type = PACKET_TYPE.SPAWN_PLAYER
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	return info

static func create_from_data(data: PackedByteArray) -> SpawnPlayer:
	var info := SpawnPlayer.new()
	info.decode(data)
	return info
