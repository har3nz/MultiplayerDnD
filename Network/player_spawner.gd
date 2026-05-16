extends Node2D


@export var barbarian = preload("res://Characters/barbarian/barbarian.tscn")
@export var bard = preload("res://Characters/bard/bard.tscn")
@export var druid = preload("res://Characters/druid/druid.tscn")
@export var rogue = preload("res://Characters/rogue/rogue.tscn")
@export var wizard = preload("res://Characters/wizard/wizard.tscn")

func _enter_tree() -> void:
	ClientNetworkGlobals.spawn_player.connect(spawn_player)
	ServerNetworkGlobals.spawn_player.connect(spawn_player)

func spawn_player(id: int, selected_class: int) -> void:
	if get_node_or_null(str(id)) != null:
			return
		
	var player
	match selected_class:
		EnumHandler.CLASSES.WIZARD:
			player = wizard.instantiate()
		EnumHandler.CLASSES.DRUID:
			player = druid.instantiate()
		EnumHandler.CLASSES.BARD:
			player = bard.instantiate()
		EnumHandler.CLASSES.ROGUE:
			player = rogue.instantiate()
		EnumHandler.CLASSES.BARBARIAN:
			player = barbarian.instantiate()
		_:
			push_error("Class with id %d not defined!" % selected_class)

	player.owner_id = id
	player.name = str(id)
	call_deferred("add_child", player)
