extends CanvasLayer

@onready var holder: Control = $Holder


func _ready():
	get_tree().paused = false
	$Holder/SettingsScreen.position.x = get_viewport().size.x


func _move_screen(x):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT)
	var desired_position = Vector2(holder.position.x + x, 0)
	tween.tween_property(holder, "position", desired_position, 0.3)


func _move_right():
	_move_screen(-get_viewport().size.x)


func _move_left():
	_move_screen(get_viewport().size.x)


func _on_settings_button_pressed():
	_move_right()


func _on_back_button_pressed():
	_move_left()


func _on_new_game_button_pressed():
	print("changing scene to root")
	get_tree().change_scene_to_file("res://scenes/root.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
