class_name MousePosition extends PacketInfo

var owner_id: int
var projectile_id: int
var projectile_type: int
var position: Vector2
var is_down: int

static func create(_owner_id: int, _projectile_id : int, _projectile_type: int, _position : Vector2, _is_down: int) -> MousePosition:
	var info := MousePosition.new()
	info.packet_type = EnumHandler.PACKET_TYPE.MOUSE_POSITION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.owner_id = _owner_id
	info.projectile_id = _projectile_id
	info.projectile_type = _projectile_type
	info.position = _position
	info.is_down = _is_down
	return info

static func create_from_data(data: PackedByteArray) -> MousePosition:
	var info := MousePosition.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(14)
	data.encode_u8(1, owner_id)
	data.encode_u8(2, projectile_id)
	data.encode_u8(3, projectile_type)
	data.encode_float(4, position.x)
	data.encode_float(8, position.y)
	data.encode_u8(13, is_down)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	owner_id = data.decode_u8(1)
	projectile_id = data.decode_u8(2)
	projectile_type = data.decode_u8(3)
	position.x = data.decode_u8(4)
	position.y = data.decode_u8(8)
	is_down = data.decode_u8(13)
