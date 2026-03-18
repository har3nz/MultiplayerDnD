extends Node


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

func spawn_player(id: int, selected_class: int) -> void:
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

	player.owner_id = id
	player.name = str(id)
	call_deferred("add_child", player)
