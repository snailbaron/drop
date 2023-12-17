extends CharacterBody2D

@export var max_speed = 400.0
@export var walk_speed = 200.0
@export var seconds_to_full_speed = 0.1
@export var seconds_to_full_stop = 0.2
@export var max_hp = 1

signal hp_changed

@onready var sprite = $AnimatedSprite2D
@onready var death_sound = $DeathSound

var acceleration = max_speed / seconds_to_full_speed
var deceleration = max_speed / seconds_to_full_stop

var hp = max_hp
var direction: Vector2 = Vector2.UP


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


func _process_input(delta):
	var input = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down")
	if input.length() == 0:
		input = Input.get_vector(
			"move_left_analog", "move_right_analog",
			"move_up_analog", "move_down_analog")
	
	var input_direction = input.normalized()
	var input_force = input.length()
	if Input.is_action_pressed("walk"):
		input_force *= walk_speed / max_speed
		
	var start_speed = velocity.length()
	
	velocity += input_direction * acceleration * delta
	var speed = velocity.length()
	if speed > 0:
		# Always hard-limit speed at max_speed
		var new_speed = min(speed, max_speed)
		
		var desired_speed = max_speed * input_force
		if desired_speed < new_speed:
			new_speed = max(0, start_speed - deceleration * delta)

		velocity *= new_speed / speed


func _update_animation():
	var speed = velocity.length()
	
	var action = "idle"
	if speed > max_speed * 0.1:
		action = "walk"
		direction = velocity.normalized()
		
	var direction_name = _direction(direction)
	sprite.animation = "%s %s" % [action, direction_name]


func _ready():
	hp = max_hp
	print("player ready, player hp " + str(hp) + ", max hp " + str(max_hp))
	sprite.play()
	print("emitting hp_changed: " + str(hp))
	hp_changed.emit(hp)


func _physics_process(delta):
	if hp > 0:
		_process_input(delta)
		_update_animation()
	move_and_slide()
	
	
func _die():
	velocity = Vector2.ZERO
	sprite.animation = "death"
	death_sound.play()
	
	
func hit(damage):
	if hp > 0:
		hp = max(0, hp - damage)
		hp_changed.emit(hp)
		if hp <= 0:
			_die()
