class_name SpawnPlayer extends PacketInfo

var peer_classes: Dictionary

static func create(peer_classes: Dictionary) -> SpawnPlayer:
	var info := SpawnPlayer.new()
	info.packet_type = PACKET_TYPE.SPAWN_PLAYER
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.peer_classes = peer_classes
	return info

static func create_from_data(data: PackedByteArray) -> SpawnPlayer:
	var info := SpawnPlayer.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	var size := peer_classes.size()
	data.resize(1 + size * 2) # 1 is the packets type, 2 bytes for peer_id and class_id
	var offset := 1
	for peer_id in peer_classes:
		data.encode_u8(offset, peer_id)
		data.encode_u8(offset + 1, peer_classes[peer_id])
		offset += 2
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	for i in range(1, data.size(), 2):
		peer_classes[data[i]] = data[i + 1]