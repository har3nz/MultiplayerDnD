extends CharacterBody2D

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var owner_id: int

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.connect(client_handle_player_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_position.disconnect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.disconnect(client_handle_player_position)

const SPEED: int = 220

var max_health: float = 50
var health: float = max_health

var fireball_scene = preload("res://scenes/Skills/fireball.tscn")
var mini_missile_scene = preload("res://scenes/Skills/mini_missile.tscn")
var mini_missile
var mouse_down: bool = false

var flipped: bool = false


func spawn_fireball() -> void:
	var fireball = fireball_scene.instantiate()
	fireball.position = self.position
	var m_pos = get_viewport().get_mouse_position()
	var fdir = m_pos - self.position
	var angle = atan2(m_pos.y - self.position.y, m_pos.x - self.position.x)
	fireball.set_dir(fdir)
	fireball.rotation = angle + 1.57
	get_parent().add_child(fireball, true)
	#GlobalMultiplayerSpawner.rpc("sv_spawn_fireball")

func spawn_mini_missile() -> void:
	mini_missile = mini_missile_scene.instantiate()
	mini_missile.position = self.position
	var m_pos = get_viewport().get_mouse_position()
	var mdir = m_pos - self.position
	mini_missile.set_dir(mdir)
	get_parent().add_child(mini_missile)
	

func _physics_process(_delta) -> void:
	#if !is_multiplayer_authority(): return

	velocity = Input.get_vector("left", "right", "up", "down") * SPEED

	if Input.is_action_just_pressed("right"):
		flipped = false
	if Input.is_action_just_pressed("left"):
		flipped = true

	# Fireball
	if Input.is_action_just_pressed("skill1"):
		spawn_fireball()


	# Mini missile logic
	if Input.is_action_just_pressed("fire"):
		spawn_mini_missile()
		mouse_down = true
	
	if Input.is_action_just_released("fire"):
		mouse_down = false
		var m_pos = get_viewport().get_mouse_position()
		mini_missile.update_mouse(m_pos, mouse_down)

	if mouse_down and mini_missile:
		var m_pos = get_viewport().get_mouse_position()
		mini_missile.update_mouse(m_pos, mouse_down)


	move_and_slide()

	PlayerPosition.create(owner_id, global_position).send(NetworkHandler.server_peer)

func server_handle_player_position(peer_id: int, player_position: PlayerPosition) -> void:
	if owner_id != peer_id: return

	global_position = player_position.position

	PlayerPosition.create(owner_id, global_position).broadcast(NetworkHandler.connection)


func client_handle_player_position(player_position: PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id: return

	global_position = player_position.position
	
