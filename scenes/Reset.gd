extends CanvasLayer

signal restart

func _on_restart_button_pressed():
	restart.emit()
	
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
