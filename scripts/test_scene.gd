extends Node



func _on_shooter_spawn_bullet(bullet):
	add_child(bullet)
