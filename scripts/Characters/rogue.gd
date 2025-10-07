extends CharacterBody2D

const SPEED: int = 280
const INV_SPEED: int = 360
var cur_speed: int = SPEED

var max_health: float = 50
var health: float = max_health

var invis: bool = false
var invis_ran_out: bool = false

var flipped: bool = false
var slash_flipped: bool = false

var slash = preload("res://scenes/Skills/slash.tscn")

var m_pos: Vector2

var dir = Vector2.ZERO
var spin_angle: float = 0.0
@export var radius: float = 20.0

func _physics_process(_delta) -> void:
	#if !is_multiplayer_authority(): return
	m_pos = get_global_mouse_position()

	velocity = Input.get_vector("left", "right", "up", "down") * cur_speed

	if Input.is_action_just_pressed("right"):
		flipped = false
	if Input.is_action_just_pressed("left"):
		flipped = true

	if Input.is_action_just_pressed("skill1"):
		if !invis_ran_out and !invis: 
			$Sprite2D.self_modulate.a = 0.5
			cur_speed = INV_SPEED
			$Timer.start()
			invis = true
	
	

	
	
	if Input.is_action_just_pressed("fire"):
		var temp_slash = slash.instantiate()
		
		temp_slash.position = position
		dir = (m_pos - global_position).normalized()
		temp_slash.global_position = global_position + dir * radius
		temp_slash.global_rotation = dir.angle()
		
		get_parent().add_child(temp_slash)
		
		

	move_and_slide()

func _on_timer_timeout() -> void:
	invis_ran_out = true
	$Sprite2D.self_modulate.a = 1
	cur_speed = SPEED
	$Cooldown.start()


func _on_cooldown_timeout() -> void:
	invis_ran_out = false
	
