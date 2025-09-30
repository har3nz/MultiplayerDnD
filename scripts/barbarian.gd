extends CharacterBody2D

var SPEED: int = 500

var max_health: float = 100
var health: float = max_health

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

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * SPEED
	m_pos = get_viewport().get_mouse_position()

	if m_pos.x < position.x:
		flipped = true
	else:
		flipped = false

	if flipped:
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
