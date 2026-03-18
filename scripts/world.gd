extends Node2D

var is_authority: bool:
	get: return NetworkHandler.is_server

@export var wizard = preload("res://scenes/Characters/wizard.tscn")
@export var bard = preload("res://scenes/Characters/bard.tscn")
@export var druid = preload("res://scenes/Characters/druid.tscn")
@export var barbarian = preload("res://scenes/Characters/barbarian.tscn")
@export var rogue = preload("res://scenes/Characters/rogue.tscn")

enum CLASSES{
	WIZARD,
	DRUID,
	BARD,
	ROGUE,
	BARBARIAN,
}

var players = []

func _ready():
	if not is_authority:
		return

	var start_packet := SpawnPlayer.create()
	start_packet.broadcast(NetworkHandler.connection)
	
	for peer_id in ServerNetworkGlobals.peer_ids:
		
		var id: int = ServerNetworkGlobals.selected_class.id
		var selected_class: int = ServerNetworkGlobals.selected_class.selected_class

		if get_node_or_null(str(id)) != null:
			return
		
		var player
		match selected_class:
			CLASSES.WIZARD:
				player = wizard.instantiate()
			CLASSES.DRUID:
				player = druid.instantiate()
			CLASSES.BARD:
				player = bard.instantiate()
			CLASSES.ROGUE:
				player = rogue.instantiate()
			CLASSES.BARBARIAN:
				player = barbarian.instantiate()
			_:
				push_error("Class with id %d not defined!" % selected_class)
		PlayerSpawner.spawn_player(id, player)