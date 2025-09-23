extends CharacterBody2D

const SPEED: int = 500

var fireball_scene = preload("res://scenes/fireball.tscn")
var mini_missile_scene = preload("res://scenes/mini_missile.tscn")
var mini_missile
var mouse_down: bool = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func spawn_fireball() -> void:
	var fireball = fireball_scene.instantiate()
	fireball.position = self.position
	var m_pos = get_viewport().get_mouse_position()
	var fdir = m_pos - self.position
	var angle = atan2(m_pos.y - self.position.y, m_pos.x - self.position.x)
	fireball.set_dir(fdir)
	fireball.rotation = angle + 1.57
	get_parent().add_child(fireball)
	#GlobalMultiplayerSpawner.rpc("sv_spawn_fireball")

func spawn_mini_missile() -> void:
	mini_missile = mini_missile_scene.instantiate()
	mini_missile.position = self.position
	var m_pos = get_viewport().get_mouse_position()
	var mdir = m_pos - self.position
	mini_missile.set_dir(mdir)
	get_parent().add_child(mini_missile)
	#GlobalMultiplayerSpawner.rpc("sv_spawn_mini_missile")
	

func _physics_process(_delta) -> void:
	#if !is_multiplayer_authority(): return

	velocity = Input.get_vector("left", "right", "up", "down") * SPEED

	# Fireball
	if Input.is_action_just_pressed("skill1"):
		spawn_fireball()


	# Mini missile logic
	if Input.is_action_just_pressed("fire"):
		spawn_mini_missile()
		mouse_down = true
	
	if Input.is_action_just_released("fire"):
		mouse_down = false
		var m_pos = get_viewport().get_mouse_position()
		mini_missile.update_mouse(m_pos, mouse_down)

	if mouse_down and mini_missile:
		var m_pos = get_viewport().get_mouse_position()
		mini_missile.update_mouse(m_pos, mouse_down)


	move_and_slide()
