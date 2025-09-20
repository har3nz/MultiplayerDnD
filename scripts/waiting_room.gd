extends Control

@onready var plr_count = $plr_count
@onready var ready_count = $ready_count
@onready var plr_list = $VBoxContainer
@onready var start_button = $Start
var player_labels: Array = []


var players: Array = []
var ready_count_int: int = 0

func _ready() -> void:
	if multiplayer.is_server():
		start_button.show()
	else:
		start_button.hide()
	multiplayer.peer_connected.connect(_on_peer_connected)
	player_labels = [
		$VBoxContainer/Player,
		$VBoxContainer/Player2,
		$VBoxContainer/Player3,
		$VBoxContainer/Player4,
		$VBoxContainer/Player5
	]

func _on_peer_connected(id: int) -> void:
	var plr_name = "Player " + str(id)
	players.append(plr_name)
	rpc("update_player_list", players)
	rpc("update_ready_count", ready_count_int)

func _on_ready_pressed() -> void:
	ready_count_int += 1
	rpc("update_ready_count", ready_count_int)

@rpc("any_peer", "call_local", "reliable")
func update_player_list(new_players: Array) -> void:
	players = new_players
	plr_count.text = "%d/5" % players.size()

	for i in range(player_labels.size()):
		if i < players.size():
			player_labels[i].text = players[i]
			player_labels[i].visible = true
		else:
			player_labels[i].visible = false

	ready_count.text = "Ready : %d/%d" % [ready_count_int, players.size()]


@rpc("any_peer", "call_local", "reliable")
func update_ready_count(new_value: int) -> void:
	ready_count_int = new_value
	ready_count.text = "Ready : %d/%d" % [ready_count_int, players.size()]


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

	for plr_name in players:
		var id = int(plr_name.replace("Player ", ""))
		#spawner.spawn_player(id)
	
