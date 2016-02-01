
extends Control

var hungerbar
var sanitybar
var restartbutton
var survivelabel
var mosqui

func _ready():
	set_pos(Vector2(get_viewport_rect().size.width / 2, get_viewport_rect().size.height / 2))
	
	hungerbar = get_node("hungerbar")	
	sanitybar = get_node("sanitybar")
	restartbutton = get_node("restartbutton")
	survivelabel = get_node("survivelabel")
	mosqui = get_node("../things/mosquilephant")
	
	restartbutton.set_hidden(true)
	set_process(true)
	pass

func _process(delta):
	var cam = self.get_node("../things/Camera2D")
	set_pos(cam.get_pos())
	
	hungerbar.set_value(mosqui.hunger)
	sanitybar.set_value(mosqui.sanity)
	
	if (mosqui.hunger <= 0 or mosqui.sanity <= 0):
		survivelabel.set_text("GAME OVER!")
		get_tree().set_pause(true)
		restartbutton.set_hidden(false)
	pass

func _on_restartbutton_pressed():
	restartbutton.set_hidden(true)
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
	print("restart")
	pass # replace with function body
