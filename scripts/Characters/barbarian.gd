extends CharacterBody2D

var SPEED: int = 320

var max_health: float = 100
var health: float = max_health

var axe_flipped: bool = false
var flipped: bool = false

var m_pos = Vector2.ZERO
@onready var axe = $Axe
@onready var ani_player = axe.get_node("AnimationPlayer")
@export var radius: float = 40.0

var spinning: bool = false
var dir = Vector2.ZERO
var spin_angle: float = 0.0
@export var spin_speed: float = 20.0
var spin_timer: float = 0.0

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var owner_id: int

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.connect(client_handle_player_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_position.disconnect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.disconnect(client_handle_player_position)


func _physics_process(delta) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * SPEED
	m_pos = get_viewport().get_mouse_position()

	if Input.is_action_just_pressed("right"):
		flipped = false
	if Input.is_action_just_pressed("left"):
		flipped = true

	if m_pos.x < position.x:
		axe_flipped = true
	else:
		axe_flipped = false

	if axe_flipped:
		$Sprite2D.scale.x = -0.5
	else:
		$Sprite2D.scale.x = 0.5

	if !spinning:
		dir = (m_pos - global_position).normalized()
		axe.global_position = global_position + dir * radius
		axe.global_rotation = dir.angle()
	else:
		spin_angle += spin_speed * delta
		dir = Vector2.RIGHT.rotated(spin_angle)
		axe.global_position = global_position + dir * radius
		axe.global_rotation = dir.angle()
		spin_timer -= delta
		if spin_timer <= 0:
			spinning = false

	if Input.is_action_just_pressed("skill1"):
		spinning = true
		spin_angle = 0.0
		spin_timer = 2.0

	if Input.is_action_just_pressed("fire"):
		ani_player.play("swing")

	move_and_slide()

	PlayerPosition.create(owner_id, global_position).send(NetworkHandler.server_peer)

func server_handle_player_position(peer_id: int, player_position: PlayerPosition) -> void:
	if owner_id != peer_id: return

	global_position = player_position.position

	PlayerPosition.create(owner_id, global_position).broadcast(NetworkHandler.connection)


func client_handle_player_position(player_position: PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id: return

	global_position = player_position.position
