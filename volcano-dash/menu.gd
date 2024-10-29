extends VBoxContainer

const MAIN = preload("res://main.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)

func _on_nux_button_pressed() -> void:
	GameState.nux_mode_enabled = true
	GameState.lava_speed = 40.0
	print("NUX mode activated: Player will be invincible.")
	get_tree().change_scene_to_packed(MAIN)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
