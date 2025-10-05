extends CharacterBody2D

var m_pos: Vector2
var flipped: bool = false

const SPEED = 300
var cur_speed = SPEED

var mouse_down: bool

var crow_scene = preload("res://scenes/Skills/crow.tscn")
var crow

func _physics_process(_delta) -> void:
	#if !is_multiplayer_authority(): return
	m_pos = get_global_mouse_position()

	velocity = Input.get_vector("left", "right", "up", "down") * cur_speed

	if Input.is_action_just_pressed("right"):
		flipped = false
	if Input.is_action_just_pressed("left"):
		flipped = true

	if Input.is_action_just_pressed("skill1"):
		crow = crow_scene.instantiate()
		crow.position = self.position
		m_pos = get_viewport().get_mouse_position()
		var mdir = m_pos - self.position
		crow.set_dir(mdir)
		get_parent().add_child(crow)
		mouse_down = true
	
	if Input.is_action_just_released("skill1"):
		mouse_down = false
		m_pos = get_viewport().get_mouse_position()
		crow.update_mouse(m_pos, mouse_down)

	if mouse_down and crow:
		m_pos = get_viewport().get_mouse_position()
		crow.update_mouse(m_pos, mouse_down)


	if Input.is_action_just_pressed("fire"):
		print()

	move_and_slide()
