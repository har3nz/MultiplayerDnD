class_name PeerList extends PacketInfo

var peer_ids: Array[int] = []

static func create(peer_ids: Array[int]) -> PeerList:
	var info := PeerList.new()
	info.packet_type = PACKET_TYPE.PEER_LIST
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.peer_ids = peer_ids
	return info

static func create_from_data(data: PackedByteArray) -> PeerList:
	var info := PeerList.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data := super.encode()
	data.resize(2 + peer_ids.size())
	data.encode_u8(1, peer_ids.size())
	for i in range(peer_ids.size()):
		data.encode_u8(2 + i, peer_ids[i])
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	var count = data.decode_u8(1)
	peer_ids.clear()
	for i in range(count):
		peer_ids.append(data.decode_u8(2 + i))
