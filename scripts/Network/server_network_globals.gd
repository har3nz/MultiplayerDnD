extends Node

signal handle_player_position(peer_id: int, player_position: PlayerPosition)
signal handle_projectile_position(peer_id: int, projectile_position: ProjectilePosition)

var peer_ids: Array[int]
var peer_classes: Dictionary = {}

func _ready() -> void:
	NetworkHandler.on_peer_connected.connect(on_peer_connected)
	NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandler.on_server_packet.connect(on_server_packet)

func on_peer_connected(peer_id: int) -> void:
	peer_ids.append(peer_id)
	
	IDAssignment.create(peer_id, peer_ids).broadcast(NetworkHandler.connection)


func on_peer_disconnected(peer_id: int) -> void:
	peer_ids.erase(peer_id)

var selected_class: ClassSelect

func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	var packet_type: int = data.decode_u8(0)
	match packet_type:
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_position.emit(peer_id, PlayerPosition.create_from_data(data))

		PacketInfo.PACKET_TYPE.CLASS_SELECT:
			selected_class = ClassSelect.create_from_data(data)
			selected_class.broadcast(NetworkHandler.connection)
			peer_classes.set(data[1], data[2])
		
		PacketInfo.PACKET_TYPE.SPAWN_PROJECTILE:
			var spawn_projectile = SpawnProjectile.create_from_data(data)
			spawn_projectile.broadcast(NetworkHandler.connection)

		PacketInfo.PACKET_TYPE.PROJECTILE_POSITION:
			handle_projectile_position.emit(peer_id, ProjectilePosition.create_from_data(data))
		_:
			push_error("Packet type with index ", data [0], " unhandled!")
