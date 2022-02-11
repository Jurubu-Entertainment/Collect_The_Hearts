extends Node

var left_num_gen = RandomNumberGenerator.new()
var right_num_gen = RandomNumberGenerator.new()

func new_seed():
	left_num_gen.randomize()
	right_num_gen.randomize()
