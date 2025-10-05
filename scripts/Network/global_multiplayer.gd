extends Node

func start_game() -> void:
	rpc("go_to_world_scene")

@rpc("any_peer", "call_local", "reliable")
func go_to_world_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
