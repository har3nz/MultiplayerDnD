class_name ClassSelect extends PacketInfo

var id: int
var selected_class: int

static func create(id: int, selected_class: int) -> ClassSelect:
	var info: ClassSelect = ClassSelect.new()
	info.packet_type = PACKET_TYPE.CLASS_SELECT
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.id = id
	info.selected_class = selected_class
	return info

static func create_from_data(data: PackedByteArray) -> ClassSelect:
	var info: ClassSelect = ClassSelect.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(3)
	data.encode_u8(1, id)
	data.encode_u8(2, selected_class)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	selected_class = data.decode_u8(2)
	
