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
var player = wizard
func spawn_player(data: ClassSelect) -> void:
	var id: int = data.id
	var selected_class: int = data.selected_class

	if get_node_or_null(str(id)) != null:
		return
	
	if selected_class == CLASSES.WIZARD:
		player = wizard.instantiate()
	if selected_class == CLASSES.DRUID:
		player = druid.instantiate()
	if selected_class == CLASSES.BARD:
		player = bard.instantiate()
	if selected_class == CLASSES.ROGUE:
		player = rogue.instantiate()
	if selected_class == CLASSES.BARBARIAN:
		player = barbarian.instantiate()
		
	player.owner_id = id
	player.name = str(id)
	call_deferred("add_child", player)
