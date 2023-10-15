extends Node


@onready var score = $HBoxContainer/MarginContainer2/Score
@onready var hi_score = $HBoxContainer/MarginContainer3/HiScore
@onready var player = $"../Player"
var isMouseVisible = false
var save_path = "user://savegame.save"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not $ConfirmationMenu.visible:
			show_confirmation_menu()
		else:
			hide_confirmation_menu()
		

	if not score or not hi_score:
		return
	score.text = "Очки: " + str( GlovalVars.score )
	hi_score.text = "Рекорд: " + str( GlovalVars.hi_score )
	
func show_confirmation_menu():
	$HBoxContainer/MarginContainer/Button.disabled = true
	$ConfirmationMenu.show()
	get_tree().paused = true

func hide_confirmation_menu():
	$ConfirmationMenu.hide()
	$HBoxContainer/MarginContainer/Button.disabled = false
	get_tree().paused = false

func _on_yes_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _on_no_pressed() -> void:
	hide_confirmation_menu()


func _on_button_pressed() -> void:
	show_confirmation_menu()



func _on_full_screen_pressed() -> void:
	var win_full = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE if win_full else DisplayServer.MOUSE_MODE_VISIBLE)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if win_full else DisplayServer.WINDOW_MODE_FULLSCREEN)
	hide_confirmation_menu()
	

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(GlovalVars.score)
	file.store_var(GlovalVars.hi_score)
	file.store_var(player.position.x)
	file.store_var(player.position.y)
func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	GlovalVars.score = file.get_var(GlovalVars.score)
	GlovalVars.hi_score = file.get_var(GlovalVars.hi_score)
	player.position.x = file.get_var(player.position.x)
	player.position.y = file.get_var(player.position.y)
	
func _on_save_pressed() -> void:
	save_game()
	



func _on_load_pressed() -> void:
	load_game()
