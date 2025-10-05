extends Area2D

var speed = 700
var direction = Vector2.ZERO
var time_passed = 0.0

var m_pos = Vector2.ZERO
var prev_m_pos = Vector2.ZERO
var mouse_velocity = Vector2.ZERO

var target

func update_mouse(_m_pos, is_down) -> void:
	prev_m_pos = m_pos
	m_pos = _m_pos
	
	mouse_velocity = (m_pos - prev_m_pos) / get_process_delta_time()

	if is_down:
		direction = direction.lerp((m_pos - position).normalized(), 0.1)
		
	else:
		if mouse_velocity.length() > 0:
			direction = mouse_velocity.normalized()
		m_pos = Vector2(-500, -500)


func set_dir(fdir: Vector2):
	direction = fdir.normalized()


func _process(delta):
	time_passed += delta

	position += direction * speed * delta