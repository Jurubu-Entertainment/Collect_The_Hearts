extends Area2D

var interact = false


func _process(_delta):
	if interact and Input.is_action_just_pressed("ui_up"):
		Highscore.highscore += Highscore.hearts
		Highscore.hearts = 0
		var config = ConfigFile.new()
		config.set_value("Highscore", "Hearts", Highscore.highscore)
		config.set_value("Has_Played", "First_Time", Globals.first_time)
		config.save("user://Highscore.cfg")
		get_tree().reload_current_scene()


func _on_Door_body_entered(body):
	if body.name == "Player":
		interact = true
