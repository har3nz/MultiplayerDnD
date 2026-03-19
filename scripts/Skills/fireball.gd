extends Area2D

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id


var direction = Vector2.ZERO
var speed = 500

var owner_id
var projectile_id
var projectile_type

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_projectile_position.connect(server_handle_projectile_position)
	ClientNetworkGlobals.handle_projectile_position.connect(client_handle_projectile_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_projectile_position.disconnect(server_handle_projectile_position)
	ClientNetworkGlobals.handle_projectile_position.disconnect(client_handle_projectile_position)

func _physics_process(delta):
	if !is_authority: return
	position += direction * speed * delta

	ProjectilePosition.create(owner_id, projectile_id, projectile_type, position, direction).send(NetworkHandler.server_peer)

func set_dir(fdir: Vector2):
	direction = fdir.normalized()

func server_handle_projectile_position(peer_id: int, projectile_position: ProjectilePosition) -> void:
	if owner_id != peer_id: return

	if projectile_position.projectile_id != projectile_id: return
	
	global_position = projectile_position.position

	ProjectilePosition.create(owner_id, projectile_id, projectile_type, global_position, direction).broadcast(NetworkHandler.connection)


func client_handle_projectile_position(projectile_position: ProjectilePosition) -> void:
	if projectile_position.owner_id != owner_id: return

	if projectile_position.projectile_id != projectile_id: return

	global_position = projectile_position.position


func _on_timer_timeout() -> void:
	self.queue_free()
