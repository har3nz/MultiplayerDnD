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

var flipped: bool = false

var projectile_counter: int = 0

enum PROJECTILES{
	FIREBALL,
	MINI_MISSILE,
	CROW
}


func _physics_process(_delta) -> void:
	if !is_authority: return

	velocity = Input.get_vector("left", "right", "up", "down") * SPEED

	if Input.is_action_just_pressed("right"):
		flipped = false
	if Input.is_action_just_pressed("left"):
		flipped = true

	# Fireball
	if Input.is_action_just_pressed("skill1"):
		SpawnProjectile.create(owner_id, projectile_counter, PROJECTILES.FIREBALL, self.position).send(NetworkHandler.server_peer)
	
	# Mini missile logic
	if Input.is_action_just_pressed("fire"):
		SpawnProjectile.create(owner_id, projectile_counter, PROJECTILES.MINI_MISSILE, self.position).send(NetworkHandler.server_peer)
	
	projectile_counter += 1

	move_and_slide()

	PlayerPosition.create(owner_id, global_position).send(NetworkHandler.server_peer)

func server_handle_player_position(peer_id: int, player_position: PlayerPosition) -> void:
	if owner_id != peer_id: return

	global_position = player_position.position

	PlayerPosition.create(owner_id, global_position).broadcast(NetworkHandler.connection)


func client_handle_player_position(player_position: PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id: return

	global_position = player_position.position
	
