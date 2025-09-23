extends Area2D

var direction = Vector2.ZERO
var speed = 500


func _physics_process(delta):
	position += direction * speed * delta

func set_dir(fdir: Vector2):
	direction = fdir.normalized()
