extends AudioStreamPlayer

export var _title_screen = false
export var _playing = false


func _process(_delta):
	if _title_screen:
		pitch_scale = 0.75
	if _playing:
		pitch_scale = 1


func _on_Game_Music_finished():
	playing = true
