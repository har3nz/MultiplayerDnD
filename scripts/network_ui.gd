extends Control


func _on_client_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")
	print("switched scene")
	NetworkHandler.start_client()
	

func _on_server_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")
	print("switched scene")
	NetworkHandler.start_server()
	print("server started")

