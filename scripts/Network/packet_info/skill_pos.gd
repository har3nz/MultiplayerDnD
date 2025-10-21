class_name SkillPosition extends PacketInfo

var rotation: float
var position: Vector2

static func create(position: Vector2, rotation: int) -> SkillPosition:
	var info: SkillPosition = SkillPosition.new()
	info.packet_type = PACKET_TYPE.SKILL_POSITION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.rotation = rotation
	info.position = position
	return info

static func create_from_data(data: PackedByteArray) -> SkillPosition:
	var info: SkillPosition = SkillPosition.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(12)
	data.encode_float(0, position.x)
	data.encode_float(4, position.y)
	data.encode_float(8, rotation)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	rotation = data.decode_float(8)
	position = Vector2(data.decode_float(2), data.decode_float(6))
	


