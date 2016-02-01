
extends Camera2D

func _ready():
	make_current()	
	set_process(true)
	pass

func _process(delta):
	var mosquPos = Vector2(get_node("../mosquilephant/mosquilephanthing").get_pos())
	set_pos(Vector2(mosquPos.x, mosquPos.y - 150))
	pass
