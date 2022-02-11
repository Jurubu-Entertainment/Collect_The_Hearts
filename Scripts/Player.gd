extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200
export (float, 0.0, 10.0) var accel = 1.0
export (float, 0.0, 10.0) var fric = 5.0
export var jumps : int = 2
export var jump_effect : PackedScene


var velocity = Vector2()
var jumping = false
var idle_left = false
var idle_right = true
var dir = 0

onready var animplayer = $AnimationPlayer
onready var sprite = $Sprite


func get_input():
	velocity.x = 0
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')
	
	# Reset available jumps
	if is_on_floor():
		jumps = 2
	# Jump
	if jump and jumps != 0:
		animplayer.play("Air")
		jumps -= 1
		jumping = true
		velocity.y = jump_speed
		if not is_on_floor():
			var child = jump_effect.instance()
			owner.add_child(child)
			child.global_transform = $Jump_Effect_Pos.global_transform
		
	# Right movement
	if right and not left:
		sprite.flip_h = true
		if idle_left:
			velocity.x = 0
			dir = 0
			accel = 0
			idle_left = false
		idle_right = true
		if dir >= 0 and dir != 1:
			dir += 0.1
		if dir > 1:
			dir = 1
		if accel != 0.35:
			accel += 0.015
		if accel > 0.35:
			accel = 0.35
		velocity.x = lerp(velocity.x, dir * run_speed, accel)
	# Left movement
	if left and not right:
		sprite.flip_h = false
		if idle_right:
			velocity.x = 0
			dir = 0
			accel = 0
			idle_right = false
		idle_left = true
		if dir <= 0 and dir != -1:
			dir -= 0.1
		if dir < 1:
			dir = -1
		if accel != 0.35:
			accel += 0.015
		if accel > 0.35:
			accel = 0.35
		velocity.x = lerp(velocity.x, dir * run_speed, accel)
	
	# Other under the hood code
	
	if right and left:
		dir = 0
		accel = 0
		velocity.x = lerp(velocity.x, 0, fric)
		if is_on_floor():
			animplayer.play("Idle")
	
	if not right and not left:
		dir = 0
		accel = 0
		velocity.x = lerp(velocity.x, 0, fric)
		if is_on_floor():
			animplayer.play("Idle")
	
	if right or left and is_on_floor():
		animplayer.play("Walk")
	
	if not is_on_floor():
		animplayer.play("Air")


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
