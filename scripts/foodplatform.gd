
extends Node2D

export var maxFood = 5

var fp_anim

var foodCount = 0

func _ready():
	set_pos(Vector2(get_viewport_rect().size.width / 2 + 500, get_viewport_rect().size.height / 2 - 420))
	
	fp_anim = get_node("fp_anim")
	
	set_process(true)
	pass
	
func _process(delta):
	pass
		
func dispense():
	fp_anim.stop()
	fp_anim.play("dispense")

	pass

func _on_Timer_timeout():
	if (foodCount < maxFood):		
		dispense()
	pass
