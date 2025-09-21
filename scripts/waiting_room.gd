extends Control

@onready var plr_count = $plr_count
@onready var ready_count = $ready_count
@onready var plr_list = $VBoxContainer
@onready var start_button = $Start
var player_labels: Array = []

var players: Array = []

func _ready() -> void:
	if multiplayer.is_server():
		start_button.show()
	else:
		start_button.hide()

	multiplayer.connect("peer_connected", Callable(self, "_on_peer_connected"))

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
	rpc("sync_ready_count")

func _on_ready_pressed() -> void:
	rpc("increase_ready_count")

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

@rpc("authority", "call_remote", "reliable")
func increase_ready_count() -> void:
	var current = int(ready_count.text.split(":")[1].split("/")[0].strip())
	current += 1
	ready_count.text = "Ready : %d/%d" % [current, players.size()]
	rpc("sync_ready_count", current)

@rpc("any_peer", "call_local", "reliable")
func sync_ready_count(current_value: int) -> void:
	ready_count.text = "Ready : %d/%d" % [current_value, players.size()]

func _on_start_pressed() -> void:
	GlobalMultiplayer.start_game()
