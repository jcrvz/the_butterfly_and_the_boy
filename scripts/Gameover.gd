extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.kill_player.connect(game_over)
	$VBoxContainer/RestartButton.grab_focus()

func _on_button_pressed():
	get_tree().reload_current_scene()
	
func game_over():
	self.show()


func _on_title_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
