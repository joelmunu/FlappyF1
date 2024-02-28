extends Control

func _on_easy_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	
func _on_exit_button_pressed():
	get_tree().quit()

func _ready():
	$AudioStreamPlayer2D.play()
