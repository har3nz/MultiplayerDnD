extends CharacterBody2D

const SPEED = 320
var cur_speed = SPEED

var flipped: bool

var m_pos: Vector2

func _physics_process(_delta) -> void:
	#if !is_multiplayer_authority(): return
	m_pos = get_global_mouse_position()

	velocity = Input.get_vector("left", "right", "up", "down") * cur_speed

	if Input.is_action_just_pressed("right"):
		flipped = false
	if Input.is_action_just_pressed("left"):
		flipped = true

	

	move_and_slide()