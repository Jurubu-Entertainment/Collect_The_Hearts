extends Control

onready var heart_score = $Label


func _physics_process(_delta):
	heart_score.text = str("x " ,Highscore.hearts + Highscore.highscore)
