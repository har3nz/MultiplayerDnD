extends Area2D

var amplitude = 200
var speed = 700
var direction = Vector2.ZERO
var time_passed = 0.0

var distance
var m_pos = Vector2.ZERO
var prev_m_pos = Vector2.ZERO
var mouse_velocity = Vector2.ZERO

var circling: bool = false
var radius: int = 30
var angle: float

var target

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_skill_position.connect(server_handle_skill_position)
	ClientNetworkGlobals.handle_skill_position.connect(client_handle_skill_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_skill_position.disconnect(server_handle_skill_position)
	ClientNetworkGlobals.handle_skill_position.disconnect(client_handle_skill_position)

func update_mouse(_m_pos, is_down) -> void:
	prev_m_pos = m_pos
	m_pos = _m_pos
	
	mouse_velocity = (m_pos - prev_m_pos) / get_process_delta_time()
	
	if is_down:
		direction = (m_pos - position).normalized()
	else:
		if mouse_velocity.length() > 0:
			direction = mouse_velocity.normalized()
		m_pos = Vector2(-500, -500)


func set_dir(fdir: Vector2):
	direction = fdir.normalized()


func _process(delta):
	time_passed += delta
	distance = position.distance_to(m_pos)
	

	if distance < 15:
		circling = true
	elif distance > 42 and circling:
		circling = false

	if circling:
		circular_motion(delta)
	else:
		position += direction * speed * delta
		var perp = Vector2(-direction.y, direction.x)
		position += perp * sin(time_passed * 20) * amplitude * delta

	SkillPosition.create(global_position, rotation).send(NetworkHandler.server_peer)

func server_handle_skill_position(skill_position: SkillPosition, rotation: float) -> void:

	global_position = skill_position.position

	SkillPosition.create(global_position, rotation).broadcast(NetworkHandler.connection)


func client_handle_skill_position(skill_position: SkillPosition) -> void:

	global_position = skill_position.position


func circular_motion(delta) -> void:
	angle += delta * 4
	var wobble = sin(time_passed * 20) * 10
	var effective_radius = radius + wobble
	position.x = m_pos.x + effective_radius * cos(angle)
	position.y = m_pos.y + effective_radius * sin(angle)
