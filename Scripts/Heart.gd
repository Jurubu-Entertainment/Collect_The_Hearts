extends Area2D

var collected = false


func _on_Heart_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("collect")
		Highscore.hearts += 1




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
