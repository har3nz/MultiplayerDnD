extends Control

@onready var plr_count = $plr_count
var plr_count_int : int = 0

@onready var ready_count = $ready_count
@export var ready_count_int: int = 0

@onready var plr_list = $VBoxContainer

func add_to_plr_list(player_name: String) -> void:
	plr_count_int += 1
	plr_count.text = "%d/5" % plr_count_int

	var new_label = $Label1.duplicate()
	plr_list.add_child(new_label)
	new_label.text = "Player " + str(plr_count_int)

func update_plr_list() -> void:
	

func _ready() -> void:
	multiplayer.peer_connected.connect(add_to_plr_list)

func _on_ready_pressed() -> void:
	ready_count_int += 1
	rpc("update_ready_count", ready_count_int)

@multiplayer_rpc("any_peer")
func update_ready_count(new_value: int) -> void:
	ready_count_int = new_value
	ready_count.text = "Ready : %d/%d" % [ready_count_int, plr_count_int]
