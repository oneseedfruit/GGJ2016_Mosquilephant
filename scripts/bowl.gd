
extends Area2D

var hunger_value = 0
var weight_value = 0

func _ready():
	set_process(true)
	pass

func _process(delta):
	hunger_value = rand_range(0, 5)
	weight_value = hunger_value / 1000
	pass

func bowl():
	pass

func getHunterPoints():
	return hunger_value
	
func getWeightPoints():
	return weight_value
