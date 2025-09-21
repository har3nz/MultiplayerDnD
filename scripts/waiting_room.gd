extends Control

@onready var plr_count = $plr_count
@onready var plr_list = $VBoxContainer
@onready var start_button = $Start
var player_labels: Array = []
var current: int = 0
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


func _on_start_pressed() -> void:
	GlobalMultiplayer.start_game()


func _on_barbarian_pressed() -> void:
	send_class_to_server.rpc("barbarian")

func _on_rogue_pressed() -> void:
	send_class_to_server.rpc("rogue")

func _on_bard_pressed() -> void:
	send_class_to_server.rpc("bard")

func _on_druid_pressed() -> void:
	send_class_to_server.rpc("druid")

func _on_wizard_pressed() -> void:
	send_class_to_server.rpc("wizard")

var player_data = {}

@rpc("any_peer", "call_remote", "reliable")
func send_class_to_server(_class_name: String):
	if multiplayer.is_server():
		var id = multiplayer.get_remote_sender_id()
		multiplayer.set_peer_meta(id, "Class", _class_name)
		for _id in multiplayer.get_peers():
			var player_class = multiplayer.get_peer_meta(_id, "Class")
			print("Player %d is %s" % [_id, str(player_class)])
