
extends Node2D

var speed = 150

var mosqui
var mp_anim
var mp_thing
var mp_sprites

# -1: idle
# 0: left
# 1: right
var direction = -1 

var flipped = false

func _ready():	
	mosqui = get_node("mosquilephant")
	mp_anim = get_node("mosquilephant/mp_anim")
	mp_thing = get_node("mosquilephant/mosquilephanthing")
	mp_sprites = get_node("mosquilephant/mosquilephanthing/mosquilephantsprites")
	
	mp_anim.play("walk")
	mp_anim.set_speed(0)
	
	set_fixed_process(true)
	set_process_input(true)
	pass

func _fixed_process(delta):
	if (direction == 0): #move left
		mp_thing.set_linear_velocity(Vector2(-speed, mp_thing.get_linear_velocity().y))
	elif (direction == 1): #move right
		mp_thing.set_linear_velocity(Vector2(speed, mp_thing.get_linear_velocity().y))
	else: #stop
		mp_thing.set_linear_velocity(Vector2(0, mp_thing.get_linear_velocity().y))		
	pass

func _input(event):
	if (event.type == InputEvent.KEY):
		#if left key is pressed
		if (event.is_action_pressed("left")):			
			direction = 0 #set direction to left				
			if (not mosqui.state == 3): #if not flying
				mp_anim.play("walk") #play walk animation
				mosqui.state = 1	 #set state to walking
			mp_anim.set_speed(1)     #play animation
		#if right key is pressed
		elif (event.is_action_pressed("right")):			
			direction = 1 #set direction to right			
			if (not mosqui.state == 3): #if not flying
				mp_anim.play("walk") #play walk animation
				mosqui.state = 1     #set state to walking				
			mp_anim.set_speed(1)     #play animation
		#if down key is pressed
		elif (event.is_action_pressed("down")):
			if (mosqui.state == 3): #if flying
				mp_anim.set_speed(0)#stop animation	
				mosqui.state = 0    #set state to idling
				mosqui.set_flying(false) #not flying
			elif (mosqui.state == 2):#if flapping			
				mosqui.state = 0     #set state to idling
				
		#if left key or right key is released
		if (event.is_action_released("left") or event.is_action_released("right")):
			direction = -1 #set direction to idle
			#if falling 
			if (not mp_thing.get_linear_velocity().y < 0.5 and mp_thing.get_linear_velocity().y > 0):
				if (not mosqui.state == 3): #if not flying		
					mp_anim.play("flap")	#play flap animation	
					mp_anim.set_speed(1)    #start animation
			mosqui.state = 0        #set state to idling
				
		if (event.is_action_pressed("flap")):	
			if (mosqui.flyable):
				mp_anim.play("fly")
				mosqui.state = 3
			else:			
				mp_anim.play("flap")				
				mosqui.state = 2			
			mp_anim.set_speed(1)
		
		if (mosqui.state == 0 and event.is_action_pressed("eat")):
			mp_anim.play("eat")
			mp_anim.set_speed(1)
			mosqui.state = 4
		
	_direction_process(direction)
	pass

func _direction_process(direction):
	if (direction == 0 and mp_sprites.get_scale().x < 0):
		mosqui.flip_x()		
	elif (direction == 1 and mp_sprites.get_scale().x > 0):
		mosqui.flip_x()
	pass