extends Node2D

export var low = 0
export var high = 0
export var title : PackedScene
export var sound : PackedScene

onready var levels = $Level
onready var player = $Player/Player


func _ready():
	level_random()
	happy_mothers_day()


func happy_mothers_day():
	if Globals.first_time == true:
		if Highscore.highscore >= 10:
			Globals.first_time = false
			var config = ConfigFile.new()
			var config_path = "user://Highscore.cfg"
			config.set_value("Has_Played", "First_Time", Globals.first_time)
			config.set_value("Highscore", "Hearts", Highscore.highscore)
			config.save(config_path)
			$CanvasLayer/AnimationPlayer.play("Appear")


func level_random():
	var left_half = $Level/Left_Half
	var right_half = $Level/Right_Half
	var left
	var right
	if right_half.get_child_count() < 0:
		left = $Level/Left_Half/Left
	if left_half.get_child_count() < 0:
		right = $Level/Right_Half/Right
	
	var left_num = RanNum.left_num_gen.randi_range(low, high)
	var right_num = RanNum.right_num_gen.randi_range(low, high)
	if left != null:
		left.queue_free()
		left = null
	if right != null:
		right.queue_free()
		right = null
	
	if left == null:
		var child
		if left_num == 1:
			child = levels.left_01.instance()
			left_half.add_child(child)
		if left_num == 2:
			child = levels.left_02.instance()
			left_half.add_child(child)
		if left_num == 3:
			child = levels.left_03.instance()
			left_half.add_child(child)
		
		player.global_position = $Level/Left_Half/Left/Player_Spawn.global_position
	
	if right == null:
		var child
		if right_num == 1:
			child = levels.right_01.instance()
			right_half.add_child(child)
		if right_num == 2:
			child = levels.right_02.instance()
			right_half.add_child(child)
		if right_num == 3:
			child = levels.right_03.instance()
			right_half.add_child(child)
		

func _process(_delta):
	var esc = Input.is_action_just_pressed("ui_cancel")
	if esc:
		get_tree().change_scene_to(title)


func _on_Continue_pressed():
	$CanvasLayer/Control.hide()
	play_sound()


func _on_Quit_pressed():
	play_sound()
	get_tree().change_scene_to(title)


func play_sound():
	var child = sound.instance()
	self.add_child(child)
