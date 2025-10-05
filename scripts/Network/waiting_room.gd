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
	ClassHandler.rpc("assign_class", multiplayer.get_unique_id(), "barbarian")

func _on_rogue_pressed() -> void:
	ClassHandler.rpc("assign_class", multiplayer.get_unique_id(), "rogue")

func _on_bard_pressed() -> void:
	ClassHandler.rpc("assign_class", multiplayer.get_unique_id(), "bard")

func _on_druid_pressed() -> void:
	ClassHandler.rpc("assign_class", multiplayer.get_unique_id(), "druid")

func _on_wizard_pressed() -> void:
	ClassHandler.rpc("assign_class", multiplayer.get_unique_id(), "wizard")

