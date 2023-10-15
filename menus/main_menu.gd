extends CanvasLayer



func _on_start_game_pressed() -> void:
	GlovalVars.score = 0
	if not GlovalVars.hi_score:
		GlovalVars.hi_score = 0
	get_tree().change_scene_to_file("res://lvls/world.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_h_iscore_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/hall_of_fame.tscn")





func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file("res://control.tscn")
