extends Area2D

@export var movement_vector = Vector2.ZERO
@export var bullet_damage = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += movement_vector * delta


func _on_body_entered(body):
	if body.name == "Player":
		body.hit(bullet_damage)
