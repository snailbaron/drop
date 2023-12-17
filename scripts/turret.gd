extends StaticBody2D

@export var reload_seconds = 3.0
@export var max_ammo = 3
@export var shooting_pause = 0.5
@export var bullet_speed = 200

var Bullet = preload("res://scenes/bullet.tscn")

var object_to_shoot: Node2D = null
var ready_to_shoot: bool = true

signal try_shooting


func _ready():
	try_shooting.connect(func(): await _attack_if_possible())


func _shoot_target(target: Node2D):
	var direction_to_target = global_position.direction_to(
		target.global_position)
	var movement_vector = direction_to_target * bullet_speed
	
	var bullet = Bullet.instantiate()
	bullet.rotation = direction_to_target.angle()
	bullet.movement_vector = movement_vector
	call_deferred("add_child", bullet)
	
	$ShotSound.play()
	
	
func _attack_if_possible():
	print("trying to attack")
	if not object_to_shoot or not ready_to_shoot:
		return

	ready_to_shoot = false
	var target = object_to_shoot
	for i in range(max_ammo):
		if i > 0:
			await get_tree().create_timer(
				shooting_pause, false, true, false).timeout
		_shoot_target(target)
		
	await get_tree().create_timer(reload_seconds, false, true, false).timeout
	ready_to_shoot = true
	

func _on_proximity_range_body_entered(body):
	if body.name == "Player":
		object_to_shoot = body
		print("emitting signal")
		try_shooting.emit()


func _on_proximity_range_body_exited(body):
	if body.name == "Player":
		object_to_shoot = null
