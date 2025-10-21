extends Node

var fireball_scene = preload("res://scenes/Skills/fireball.tscn")

var is_server: bool:
	get: return NetworkHandler.is_server

func spawn_mini_missile(mini_missile, mdir, pos) -> void:
	if !is_server: return
	
	mini_missile.position = pos
	mini_missile.set_dir(mdir)
	call_deferred("add_child", mini_missile)
	print("spawned missile")

	
func spawn_fireball(fdir, angle, ppos) -> void:
	if !is_server: return
	var fireball = fireball_scene.instantiate()
	fireball.position = ppos
	fireball.set_dir(fdir)
	fireball.rotation = angle + 1.57
	

func spawn_slash() -> void:
	if !is_server: return

func spawn_crow() -> void:
	if !is_server: return