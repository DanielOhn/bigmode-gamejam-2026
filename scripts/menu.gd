extends Control
@onready var explain_menu = $"../ExplainMenu"
@onready var credit_menu = $"../CreditMenu"

func _on_start_btn_pressed():
	explain_menu.visible = true
	


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/sealy_slide.tscn")


func _on_close_btn_pressed():
	credit_menu.visible = false


func _on_credit_btn_pressed():
	credit_menu.visible = true
