extends Node2D

func _ready():
	if multiplayer.is_server():
		for plr_name in WaitingRoom.players:
			var id = int(plr_name.replace("Player ", ""))
			GlobalMultiplayerSpawner.network_player = preload("res://scenes/character_player.tscn")
			GlobalMultiplayerSpawner.init(id)
