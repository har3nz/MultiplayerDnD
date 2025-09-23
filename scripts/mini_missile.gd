extends Area2D

var amplitude = 200
var speed = 700
var direction = Vector2.ZERO
var time_passed = 0.0

var distance

var m_pos

func update_mouse(_m_pos) -> void:
	m_pos = _m_pos
	direction = (m_pos - position).normalized()

func set_dir(fdir: Vector2):
	direction = fdir.normalized()

func _process(delta):
	time_passed += delta
	
	distance = position.distance_to(m_pos)

	if distance < 60:
		print("close")

	position += direction * speed * delta
	
	var perp = Vector2(-direction.y, direction.x)
	position += perp * sin(time_passed * 20) * amplitude * delta
