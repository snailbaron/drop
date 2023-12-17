extends CanvasLayer

@onready var hp_bar = $HpBar


func on_hp_change(hp: int):
	print("UI got on_hp_change")
	for i in range(hp):	
		hp_bar.get_child(i).visible = true
	for i in range(hp, 10):
		hp_bar.get_child(i).visible = false
