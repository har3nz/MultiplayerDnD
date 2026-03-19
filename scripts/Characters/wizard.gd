extends CharacterBody2D

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id
var owner_id: int #Is defined in player_spawner.gd

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.connect(client_handle_player_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_position.disconnect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.disconnect(client_handle_player_position)

const SPEED: int = 220

var max_health: float = 50
var health: float = max_health

var mini_missile_scene = preload("res://scenes/Skills/mini_missile.tscn")
var mini_missile
var mouse_down: bool = false

var flipped: bool = false

var projectile_counter: int = 0

enum PROJECTILES{
	FIREBALL,
	MINI_MISSILE,
	CROW
}

func spawn_fireball() -> void:
	var m_pos = get_viewport().get_mouse_position()
	var fdir = (m_pos - self.position).normalized()
	var angle = atan2(m_pos.y - self.position.y, m_pos.x - self.position.x)
	SpawnProjectile.create(owner_id, projectile_counter, PROJECTILES.FIREBALL, self.position, fdir).send(NetworkHandler.server_peer)
	projectile_counter += 1


func spawn_mini_missile() -> void:
	var m_pos = get_viewport().get_mouse_position()
	var mdir = (m_pos - self.position).normalized()
	SpawnProjectile.create(owner_id, projectile_counter, PROJECTILES.MINI_MISSILE, self.position, mdir).send(NetworkHandler.server_peer)
	projectile_counter += 1

var prev_mouse_pos = Vector2.ZERO

var direction = Vector2.ZERO

func calculate_direction(mouse_pos: Vector2, projectile_pos: Vector2, is_down: bool):
	
	var mouse_velocity = (mouse_pos - prev_mouse_pos) / get_process_delta_time()
	
	if is_down:
		direction = mouse_pos - projectile_pos
	else:
		if mouse_velocity.length() > 0:
			direction = mouse_velocity

	prev_mouse_pos = mouse_pos
	return direction.normalized()

func _physics_process(_delta) -> void:
	if !is_authority: return

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
		var ProjectilePosition = ProjectilePosition.create(owner_id, projectile_counter - 1, PROJECTILES.MINI_MISSILE, global_position, direction)
		ProjectilePosition.send(NetworkHandler.server_peer)
	
	if Input.is_action_just_released("fire"):
		mouse_down = false
		var m_pos = get_viewport().get_mouse_position()
		var ProjectilePosition = ProjectilePosition.create(owner_id, projectile_counter - 1, PROJECTILES.MINI_MISSILE, global_position, direction)
		ProjectilePosition.send(NetworkHandler.server_peer)

		
	if mouse_down and mini_missile:
		var m_pos = get_viewport().get_parent().get_mouse_position()
		

	move_and_slide()

	PlayerPosition.create(owner_id, global_position).send(NetworkHandler.server_peer)

func server_handle_player_position(peer_id: int, player_position: PlayerPosition) -> void:
	if owner_id != peer_id: return

	global_position = player_position.position

	PlayerPosition.create(owner_id, global_position).broadcast(NetworkHandler.connection)


func client_handle_player_position(player_position: PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id: return

	global_position = player_position.position
	
