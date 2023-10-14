extends Node

@onready var score = $HBoxContainer/MarginContainer2/Score
@onready var hi_score = $HBoxContainer/MarginContainer3/HiScore

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
