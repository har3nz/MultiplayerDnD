extends Control

func _on_client_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")
	NetworkHandler.start_client()
	NetworkHandler.on_client_packet.connect(_on_client_packet)

func _on_server_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")
	NetworkHandler.start_server()

func _on_client_packet(data: PackedByteArray) -> void:
	var type = data.decode_u8(0)

	match type:
		PacketInfo.PACKET_TYPE.PEER_LIST:
			var packet := PeerList.create_from_data(data)
			var waiting_room = get_tree().current_scene
			waiting_room.update_player_list_from_peers(packet.peer_ids)
