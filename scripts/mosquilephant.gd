
extends Node2D

export var hunger = 2500.0
export var sanity = 2500.0

var weight
var maxFlyingHeight = 50

var mp_anim
var mp_thing
var mp_trunk_thing
var mp_sprites

var mp_thing_y_temp

var anim_walk
var anim_flap
var anim_eat

var player

# 0: idle
# 1: walk
# 2: flap
# 3: fly
# 4: eat
var state = 0

var flyable = false
var atFood = false
var foodThing
var velocity

var instanceID

func _ready():
	set_pos(Vector2(get_viewport_rect().size.width / 2, get_viewport_rect().size.height / 2))
	
	mp_anim = get_node("mp_anim")
	mp_thing = get_node("mosquilephanthing")	
	mp_trunk_thing = mp_thing.get_node("mosquilephantsprites/neck/trunk_upper/trunk_middle/trunk_lower/trunk_lower_thing")
	mp_sprites = get_node("mosquilephanthing/mosquilephantsprites")
	
	weight = mp_thing.get_mass()
	mp_thing.set_mode(mp_thing.MODE_CHARACTER)
	mp_thing.set_bounce(false)
	
	anim_walk = mp_anim.get_animation("walk")
	anim_flap = mp_anim.get_animation("flap")
	anim_eat = mp_anim.get_animation("eat")
	
	player = get_node("../../SamplePlayer2D")
	
	set_process(true)	
	set_fixed_process(true)
	pass

func _process(delta):
	weight = mp_thing.get_mass()
	mp_sprites.get_node("body").set_scale(Vector2(weight/1, weight/1))
	
	if (not state == 3):
		mp_thing_y_temp = mp_thing.get_pos().y
	
	if (weight <= 1.5):
		flyable = true
	else:
		flyable = false
		
	if (state == 3):
		set_flying(true)
	else:
		set_flying(false)
	
	var sanityMaxDrop = 0.7
	if (weight > 1.5):
		sanityMaxDrop = 1
		get_node("../../GUI/sanitylabel").set_text("OVERWEIGHT!!!")
	else:
		get_node("../../GUI/sanitylabel").set_text("Don't Move to Regain Sanity")
	
	if (state == 0):
		sanity += rand_range(0, sanityMaxDrop)
	elif (not state == 0):
		sanity -= rand_range(0, sanityMaxDrop)
		
	if (atFood):
		hunger += foodThing.getHunterPoints();
		mp_thing.set_mass(mp_thing.get_mass() + foodThing.getWeightPoints())
	
	if (not state == 4):
		if (state == 1 or state == 3 or state == 0 or state == 2):
			if (hunger > 0):
				hunger -= rand_range(0, 2)
			if (weight > 1 && not state == 0):
				mp_thing.set_mass(mp_thing.get_mass() - rand_range(0, 0.005))
		
	velocity = mp_thing.get_linear_velocity()
	if (state == 0 or (not state == 4 and not state == 3 and not state == 1 and not state == 2)):
		if (velocity.y < 0.5):
			mp_anim.play("flap")
			mp_anim.set_speed(1)

	manageAudioState()
	pass

func _fixed_process(delta):
	
	pass

func flip_x():
	mp_sprites.set_scale(Vector2(mp_sprites.get_scale().x * -1, get_scale().y))	
	pass

func manageAudioState():
	if (state == 4 and not player.is_voice_active(0)):
		player.voice_set_volume_scale_db(0, 24)
		player.play("slurp", 0)
		if (not state == 4):
			player.stop_voice(0)			
	elif (state == 3):
		player.play("buzz", 0)
		player.voice_set_volume_scale_db(0, 7)
		if (not state == 3):
			player.stop_voice(0)
	elif (state == 2 and not player.is_voice_active(0)):
		player.play("distress", 0)
		player.voice_set_volume_scale_db(0, 7)
		if (not state == 2):
			player.stop_voice(0)
	elif (state == 1 and not player.is_voice_active(0)):
		player.play("tiptoe", 0)
		player.voice_set_volume_scale_db(0, 7)
		if (not state == 1):
			player.stop_voice(0)
	pass

func set_flying(isFlying):
	if (isFlying):		
		if (mp_thing.get_pos().y - mp_thing_y_temp >= -maxFlyingHeight):
			mp_thing.set_applied_force(Vector2(0, -200))
		else:
			mp_thing.set_applied_force(Vector2(0, -70))		
	else:
		mp_thing.set_applied_force(Vector2(0, 0))
	pass

func _on_trunk_lower_thing_area_enter( food ):
	if (food.has_method("bowl")):
		if (state == 4):
			atFood = true
			foodThing = food
	else:
		atFood = false
	pass # replace with function body


func _on_trunk_lower_thing_area_exit( food ):
	if (food.has_method("bowl")):
		if (not state == 4):
			atFood = false
	pass # replace with function body
