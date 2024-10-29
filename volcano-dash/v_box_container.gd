extends VBoxContainer

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu_screen.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
