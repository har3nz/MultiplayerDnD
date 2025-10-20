extends Control

@onready var plr_count = $plr_count
@onready var plr_list = $VBoxContainer
@onready var start_button = $Start
var player_labels: Array = []
var players: Array = []
var is_authority: bool:
	get: return NetworkHandler.is_server

func _ready() -> void:
	if is_authority:
		start_button.show()
	else:
		start_button.hide()

	player_labels = [
		$VBoxContainer/Player,
		$VBoxContainer/Player2,
		$VBoxContainer/Player3,
		$VBoxContainer/Player4,
		$VBoxContainer/Player5
	]
	ClientNetworkGlobals.upd_list.connect(update_player_list_from_peers)

func update_player_list_from_peers(list: Array[int]) -> void:
	players = list.duplicate()
	plr_count.text = "%d/5" % players.size()

	for i in range(player_labels.size()):
		if i < players.size():
			player_labels[i].text = str(players[i])
			player_labels[i].visible = true
		else:
			player_labels[i].visible = false

func _on_start_pressed() -> void:
	if not is_authority:
		return

	var start_packet := StartGame.create()
	start_packet.broadcast(NetworkHandler.connection)

	get_tree().change_scene_to_file("res://scenes/world.tscn")
