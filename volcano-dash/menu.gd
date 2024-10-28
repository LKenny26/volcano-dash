extends VBoxContainer

const MAIN = preload("res://main.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)



func _on_nux_button_pressed() -> void:
	# TODO: add nux mode
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
