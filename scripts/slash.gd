extends Node2D

var teammates = ["barbarian", "wizard", "rogue", "bard", "druid"]

func _ready() -> void:
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name in teammates:
		pass


func _on_timer_timeout() -> void:
	queue_free()
	
