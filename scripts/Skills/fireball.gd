extends Area2D

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
	position += direction * speed * delta

	ProjectilePosition.create(owner_id, projectile_id, projectile_type, position, direction).send(NetworkHandler.server_peer)

func set_dir(fdir: Vector2):
	direction = fdir.normalized()

func server_handle_projectile_position(peer_id: int, projectile_position: ProjectilePosition) -> void:
	if owner_id != peer_id: return

	if projectile_position.projectile_id != projectile_id: return
	
	global_position = projectile_position.position
	print("server global pos : ", global_position)

	ProjectilePosition.create(owner_id, projectile_id, projectile_type, global_position, direction).broadcast(NetworkHandler.connection)


func client_handle_projectile_position(projectile_position: ProjectilePosition) -> void:
	# when the owner id is not the one updating this projectile, also ignore it.
	if projectile_position.owner_id != owner_id: return

	# and when the projectile_id doesn't match, also ignore it.
	if projectile_position.projectile_id != projectile_id: return

	# now we update the projectile position
	global_position = projectile_position.position
	print(projectile_position.position)