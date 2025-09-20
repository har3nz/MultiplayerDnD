extends CharacterBody2D

const SPEED: int = 500

func _enter_tree() -> void:
    set_multiplayer_authority(name.to_int())
    
func _physics_process(_delta) -> void:
    if !is_multiplayer_authority(): return

    velocity = Input.get_vector("left", "right", "up", "down") * SPEED

    move_and_slide()

