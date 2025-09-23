extends Node

var players: Dictionary = {}

@rpc("any_peer", "call_remote", "reliable")
func assign_class(id: int, _class: String) -> void:
	if !multiplayer.is_server(): return
	players[id] = _class
	
	"""
	for key in players.keys():
		var value = players[key]
		print(key, value)
	"""

