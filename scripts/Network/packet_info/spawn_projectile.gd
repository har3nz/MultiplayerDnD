class_name SpawnProjectile extends PacketInfo

var owner_id: int
var projectile_id: int
var projectile_type: int
var position: Vector2

static func create(owner_id: int, projectile_id : int, projectile_type: int, position : Vector2) -> SpawnProjectile:
	var info := SpawnProjectile.new()
	info.packet_type = PACKET_TYPE.SPAWN_PROJECTILE
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.owner_id = owner_id
	info.projectile_id = projectile_id
	info.projectile_type = projectile_type
	info.position = position
	return info

static func create_from_data(data: PackedByteArray) -> SpawnProjectile:
	var info := SpawnProjectile.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(13)
	data.encode_u8(1, owner_id)
	data.encode_u8(2, projectile_id)
	data.encode_u8(3, projectile_type)
	data.encode_float(4, position.x)
	data.encode_float(8, position.y)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	owner_id = data.decode_u8(1)
	projectile_id = data.decode_u8(2)
	projectile_type = data.decode_u8(3)
	position = Vector2(data.decode_float(4), data.decode_float(8))


func _to_string() -> String:
	return "owner_id: %s, projectile_id: %s, projectile_type: %s, position: %s" % [owner_id, projectile_id, projectile_type, position]