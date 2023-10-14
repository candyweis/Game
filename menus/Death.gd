extends Button





func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _on_timer_timeout() -> void:
	_on_pressed()
