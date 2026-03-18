class_name SpawnProjectile extends PacketInfo

var projectile_owner: int
var projectile_id: int
var projectile_type: int
var position: Vector2
var direction: Vector2

static func create(projectile_owner: int, projectile_id : int, projectile_type: int, position : Vector2, direction: Vector2) -> SpawnProjectile:
	var info := SpawnProjectile.new()
	info.packet_type = PACKET_TYPE.SPAWN_PROJECTILE
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.projectile_owner = projectile_owner
	info.projectile_id = projectile_id
	info.projectile_type = projectile_type
	info.position = position
	info.direction = direction
	return info

static func create_from_data(data: PackedByteArray) -> SpawnProjectile:
	var info := SpawnProjectile.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(20)
	data.encode_u8(1, projectile_owner)
	data.encode_u8(2, projectile_id)
	data.encode_u8(3, projectile_type)
	data.encode_float(4, position.x)
	data.encode_float(8, position.y)
	data.encode_float(12, direction.x)
	data.encode_float(16, direction.y)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	projectile_owner = data.decode_u8(1)
	projectile_id = data.decode_u8(2)
	projectile_type = data.decode_u8(3)
	position = Vector2(data.decode_float(4), data.decode_float(8))
	direction = Vector2(data.decode_float(12), data.decode_float(16))