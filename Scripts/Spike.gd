extends Area2D


func _on_Spike_01_body_entered(body):
	if body.name == "Player":
		Highscore.hearts = 0
		get_tree().reload_current_scene()
