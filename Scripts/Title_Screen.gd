extends Camera2D

export var sound : PackedScene
export var starting_level : String

var score

onready var master_volume = $CanvasLayer/Control/Options_Panel/NinePatchRect/Master
onready var master_volume_slider = $CanvasLayer/Control/Options_Panel/NinePatchRect/Master/HSlider
onready var music_volume = $CanvasLayer/Control/Options_Panel/NinePatchRect/Music
onready var music_volume_slider = $CanvasLayer/Control/Options_Panel/NinePatchRect/Music/HSlider
onready var effects_volume = $CanvasLayer/Control/Options_Panel/NinePatchRect/Effects
onready var effects_volume_slider = $CanvasLayer/Control/Options_Panel/NinePatchRect/Effects/HSlider

var master_vol = 0
var music_vol = 0
var effects_vol = 0



func _ready():
	GameMusic._playing = false
	GameMusic._title_screen = true
	GameMusic.pitch_scale = 0.75
	if not GameMusic.playing: GameMusic.play()
	
	var file = File.new()
	if file.file_exists("user://Highscore.cfg"):
		var score_cfg = ConfigFile.new()
		score_cfg.load("user://Highscore.cfg")
		score = score_cfg.get_value("Highscore", "Hearts", 0)
		Globals.first_time = score_cfg.get_value("Has_Played", "First_Time")
		Highscore.highscore = score
		$CanvasLayer/Control/Label/Score.text = str("Personal Best: ", score)
	else:
		Highscore.highscore = 0
		Globals.first_time = true
	
	if file.file_exists("user://Volume.cfg"):
		var vol_cfg = ConfigFile.new()
		vol_cfg.load("user://Volume.cfg")
		master_vol = vol_cfg.get_value("Volume", "Master", 1)
		music_vol = vol_cfg.get_value("Volume", "Music", 1)
		effects_vol = vol_cfg.get_value("Volume", "Effects", 1)
		master_volume_slider.value = master_vol
		music_volume_slider.value = music_vol
		effects_volume_slider.value = effects_vol
	else:
		master_vol = 1
		music_vol = 1
		effects_vol = 1
	
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(master_vol))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_vol))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear2db(effects_vol))
	
	


func _on_Start_pressed():
	RanNum.new_seed()
	play_sound()
	GameMusic._title_screen = false
	get_tree().current_scene.queue_free()
	get_tree().change_scene(starting_level)
	GameMusic._playing = true


func _on_Options_pressed():
	play_sound()
	$CanvasLayer/Control/Options_Panel.show()


func _on_Quit_pressed():
	play_sound()
	get_tree().quit()


func _on_Back_pressed():
	play_sound()
	$CanvasLayer/Control/Options_Panel.hide()
	var config = ConfigFile.new()
	config.set_value("Volume", "Master", db2linear(AudioServer.get_bus_volume_db(master_volume.bus)))
	config.set_value("Volume", "Music", db2linear(AudioServer.get_bus_volume_db(music_volume.bus)))
	config.set_value("Volume", "Effects", db2linear(AudioServer.get_bus_volume_db(effects_volume.bus)))
	config.save("user://Volume.cfg")

func play_sound():
	var child = sound.instance()
	self.add_child(child)
