extends AudioStreamPlayer



func _on_Button_Sound_finished():
	queue_free()
