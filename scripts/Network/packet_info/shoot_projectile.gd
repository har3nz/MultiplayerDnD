class_name ShootProjectile extends PacketInfo

var peer_id: int
var start_position: Vector2
var direction: Vector2
var projectile_type: int

static func create(
	peer_id: int,
	start_position: Vector2,
	direction: Vector2,
	projectile_type: int,
) -> ShootProjectile:
	var info: ShootProjectile = ShootProjectile.new()
	info.packet_type = PACKET_TYPE.SHOOT_PROJECTILE
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.peer_id = peer_id
	info.start_position = start_position
	info.direction = direction
	info.projectile_type = projectile_type
	return info


static func create_from_data(data: PackedByteArray) -> ShootProjectile:
	var info: ShootProjectile = ShootProjectile.new()
	info.decode(data)
	return info


func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(18)
	data.encode_u8(0, peer_id)
	data.encode_float(1, start_position.x)
	data.encode_float(5, start_position.y)
	data.encode_float(9, direction.x)
	data.encode_float(13, direction.y)
	data.encode_u8(17, projectile_type)
	return data


func decode(data: PackedByteArray) -> void:
	super.decode(data)
	peer_id = data.decode_u8(0)
	start_position = Vector2(data.decode_float(1), data.decode_float(5))
	direction = Vector2(data.decode_float(9), data.decode_float(13))
	projectile_type = data.decode_u8(17)
