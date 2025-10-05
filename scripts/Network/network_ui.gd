extends Control
var chosen_class = ""

func _on_client_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")
	NetworkHandler.start_client()

func _on_server_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/waiting_room.tscn")
	NetworkHandler.start_server()


