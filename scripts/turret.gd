extends StaticBody2D

@export var reload_seconds = 3.0
@export var ammo_in_magazine = 3
@export var shooting_pause = 0.5
@export var bullet_speed = 200

var ammo_left = 0
var object_to_shoot = null

var reload_timers = []
var shoot_pause_timer = Timer.new()
var can_shoot = true

var Bullet = preload("res://scenes/bullet.tscn")


func _ready():
	ammo_left = ammo_in_magazine



func _spawn_bullet():
	var direction_to_target = global_position.direction_to(
		object_to_shoot.global_position)
	var movement_vector = direction_to_target * bullet_speed
	
	var bullet = Bullet.instantiate()
	bullet.rotation = direction_to_target.angle()
	bullet.movement_vector = movement_vector
	call_deferred("add_child", bullet)
	
	$ShotSound.play()
	
	
func _on_unpause():
	can_shoot = true
	_try_shoot()


func _on_reload():
	ammo_left += 1
	_try_shoot()


func _try_shoot():
	if can_shoot and ammo_left > 0 and object_to_shoot != null:
		_spawn_bullet()
		ammo_left -= 1
		print("shot, ammo left: " + str(ammo_left))
		
		var pause_timer = get_tree().create_timer(shooting_pause, false, true, false)
		pause_timer.connect("timeout", _on_unpause)
		can_shoot = false
		
		var reload_timer = get_tree().create_timer(reload_seconds, false, true, false)
		reload_timer.connect("timeout", _on_reload)


func _on_proximity_range_body_entered(body):
	if body.name == "Player":
		object_to_shoot = body
		_try_shoot()


func _on_proximity_range_body_exited(body):
	if body.name == "Player":
		object_to_shoot = null
