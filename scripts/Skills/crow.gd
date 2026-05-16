extends Area2D

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var speed = 600
var direction = Vector2.ZERO

var m_pos = Vector2.ZERO
var prev_m_pos = Vector2.ZERO
var mouse_velocity = Vector2.ZERO

var target

var mouse_down
var free_bird = false

var owner_id
var projectile_id
var projectile_type

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_projectile_position.connect(server_handle_projectile_position)
	ClientNetworkGlobals.handle_projectile_position.connect(client_handle_projectile_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_projectile_position.disconnect(server_handle_projectile_position)
	ClientNetworkGlobals.handle_projectile_position.disconnect(client_handle_projectile_position)

func _physics_process(delta: float) -> void:
	if !is_authority: return

	m_pos = get_global_mouse_position()

	if Input.is_action_pressed("skill1"):
		mouse_down = true
		
	if Input.is_action_just_released("skill1"):
		free_bird = true
		mouse_down = false
		$Timer.start()

	if mouse_down and !free_bird:
		direction = direction.move_toward(global_position.direction_to(m_pos), 0.1)

	if !free_bird:
		position += direction * speed * delta
	if free_bird:
		position += direction.normalized() * speed * delta

	ProjectilePosition.create(owner_id, projectile_id, projectile_type, global_position).send(NetworkHandler.server_peer)

func server_handle_projectile_position(peer_id: int, projectile_position: ProjectilePosition) -> void:
	if owner_id != peer_id: return

	if projectile_position.projectile_id != projectile_id: return
	
	global_position = projectile_position.position

	ProjectilePosition.create(owner_id, projectile_id, projectile_type, global_position).broadcast(NetworkHandler.connection)

func client_handle_projectile_position(projectile_position: ProjectilePosition) -> void:
	if projectile_position.owner_id == ClientNetworkGlobals.id: return

	if projectile_position.owner_id != owner_id: return

	if projectile_position.projectile_id != projectile_id: return

	global_position = projectile_position.position

func _on_timer_timeout() -> void:
	self.queue_free()
