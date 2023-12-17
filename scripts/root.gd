extends Node

@onready var ui: CanvasLayer = $UI
@onready var player: CharacterBody2D = $Player


func _ready():
	print("connecting signal in root")
	player.hp_changed.connect(ui.on_hp_change)
	print("root ready, player hp " + str(player.hp))
	ui.on_hp_change(player.hp)
