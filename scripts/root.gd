extends Node

@onready var game: Node = $Game
@onready var hud: CanvasLayer = $Game/HUD
@onready var player: CharacterBody2D = $Game/Player
@onready var game_menu: CanvasLayer = $GameMenu


func _ready():
	game_menu.offset.x = get_viewport().size.x
	player.hp_changed.connect(hud.on_hp_change)
	hud.on_hp_change(player.hp)


func _toggle_menu():
	if get_tree().paused:
		print("returning to game")
		_return_to_game()
	else:
		print("showing menu")
		_show_menu()


func _show_menu():
	print("pausing game")
	get_tree().paused = true
	print("moving menu from " + str(game_menu.offset))
	var tween = (
		get_tree().create_tween().set_trans(Tween.TRANS_QUINT)
			.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	)
	tween.tween_property(game_menu, "offset", Vector2.ZERO, 0.3)
	tween.tween_callback(func(): print("current offset: " + str(game_menu.offset)))


func _return_to_game():
	var tween = (
		get_tree().create_tween().set_trans(Tween.TRANS_QUINT)
			.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	)
	tween.tween_property(
		game_menu, "offset", Vector2(get_viewport().size.x, 0), 0.3)
	tween.tween_callback(func(): get_tree().paused = false)


func _input(event: InputEvent):
	if event.is_action_pressed("menu"):
		print("toggling menu")
		_toggle_menu()


func _on_quit_game_button_pressed():
	get_tree().quit()


func _on_quit_to_main_menu_button_pressed():
	print("changing scene to main menu")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
