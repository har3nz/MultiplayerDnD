extends Node2D

@export var fireball = preload("res://Characters/wizard/fireball.tscn")
@export var mini_missile = preload("res://Characters/wizard/mini_missile.tscn")
@export var crow = preload("res://Characters/druid/crow.tscn")

func _enter_tree() -> void:
	ClientNetworkGlobals.spawn_skill.connect(spawn_skill)

func spawn_skill(skill_owner: int, skill_type: int, skill_id: int, position: Vector2) -> void:
	var skill
	match skill_type:
		EnumHandler.SKILLS.FIREBALL:
			skill = fireball.instantiate()
			skill.direction = position.direction_to(get_global_mouse_position())
		EnumHandler.SKILLS.MINI_MISSILE:
			skill = mini_missile.instantiate()
		EnumHandler.SKILLS.CROW:
			skill = crow.instantiate()

	skill.owner_id = skill_owner
	skill.skill_id = skill_id
	skill.skill_type = skill_type
	skill.name = str(skill_owner) + "_" + str(skill_type) + "_" + str(skill_id)
	skill.global_position = position
	call_deferred("add_child", skill)
