extends Node2D

@export var fireball = preload("res://scenes/Skills/fireball.tscn")
@export var mini_missile = preload("res://scenes/Skills/mini_missile.tscn")
@export var crow = preload("res://scenes/Skills/crow.tscn")

enum PROJECTILES{
	FIREBALL,
	MINI_MISSILE,
	CROW
}

func spawn_projectile(projectile_owner: int, projectile_type: int, projectile_id: int, position: Vector2) -> void:
	var projectile
	match projectile_type:
		PROJECTILES.FIREBALL:
			projectile = fireball.instantiate()
		PROJECTILES.MINI_MISSILE:
			projectile = mini_missile.instantiate()
		PROJECTILES.CROW:
			projectile = crow.instantiate()

	projectile.owner_id = projectile_owner
	projectile.projectile_id = projectile_id
	projectile.projectile_type = projectile_type
	projectile.name = str(projectile_owner) + "_" + str(projectile_type) + "_" + str(projectile_id)
	projectile.global_position = position
	call_deferred("add_child", projectile)
