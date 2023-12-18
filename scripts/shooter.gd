extends CharacterBody2D

@export var max_speed: float = 400.0
@export var bullet_speed: float = 600.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var proximity: Area2D = $Proximity

var direction: Vector2 = Vector2.UP

var Bullet = preload("res://scenes/bullet.tscn")

signal spawn_bullet(bullet: Node)

signal ai_update(delta: float)
signal player_entered(target: Node2D)

var hp: int = 100


func _ready():
	_think()


func _shoot_target(target: Node2D) -> void:
	var direction_to_target = global_position.direction_to(
		target.global_position)
	var movement_vector = direction_to_target * bullet_speed
	
	var bullet = Bullet.instantiate()
	bullet.position = global_position
	bullet.rotation = direction_to_target.angle()
	bullet.movement_vector = movement_vector
	spawn_bullet.emit(bullet)
	$ShotSound.play()


func _direction(vector: Vector2) -> String:
	var sector_names = [
		"right",
		"down right",
		"down",
		"down left",
		"left",
		"up left",
		"up",
		"up right"
	]
	var relative_angle = fposmod(vector.angle() + PI / 8, 2 * PI)
	var sector = int(relative_angle * 8 / (2 * PI))
	return sector_names[sector]


func _update_animation():
	var speed = velocity.length()
	
	var action = "idle"
	if speed > max_speed * 0.1:
		action = "walk"
		direction = velocity.normalized()
		
	var direction_name = _direction(direction)
	sprite.animation = "%s %s" % [action, direction_name]


func _random_point() -> Vector2:
	var viewport_size = get_viewport_rect().size
	return Vector2(
		randf_range(50, viewport_size.x - 50),
		randf_range(50, viewport_size.y - 50)
	)

func _move_to_point(target_point: Vector2) -> void:
	
	while global_position != target_point:
		var delta: float = await ai_update
	
		var move_vector = target_point - global_position
		var move_distance: float = max_speed * delta
		
		if move_distance >= move_vector.length():
			global_position = target_point
		else:
			global_position += move_vector.normalized() * move_distance


func _think():
	var target: Node2D = await player_entered
	while hp > 0:
		$AhaSound.play()
		await $AhaSound.finished
			
		for i in range(10):
			_shoot_target(target)
			await get_tree().create_timer(0.1, false, true, false).timeout

		var target_point = _random_point()
		await _move_to_point(target_point)


func _physics_process(delta: float):
	ai_update.emit(delta)
	_update_animation()
	move_and_slide()


func _on_proximity_body_entered(body: Node2D):
	if body.name == "Player":
		player_entered.emit(body)
