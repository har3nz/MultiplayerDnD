extends Node

@export var fireball = preload("res://scenes/Skills/fireball.tscn")
@export var mini_missile = preload("res://scenes/Skills/mini_missile.tscn")
@export var crow = preload("res://scenes/Skills/crow.tscn")

enum CLASSES{
	FIREBALL,
	MINI_MISSILE,
	CROW
}

func spawn_projectile(projectile_owner: int, projectile_type: int, projectile_id: int) -> void:
	var projectile
	match projectile_type:
		CLASSES.FIREBALL:
			projectile = fireball.instantiate()
		CLASSES.MINI_MISSILE:
			projectile = mini_missile.instantiate()
		CLASSES.CROW:
			projectile = crow.instantiate()

	projectile.owner_id = projectile_owner
	projectile.projectile_id = projectile_id
	projectile.projectile_type = projectile_type
	projectile.name = str(projectile_owner) + "_" + str(projectile_type) + "_" + str(projectile_id)
	call_deferred("add_child", projectile)
