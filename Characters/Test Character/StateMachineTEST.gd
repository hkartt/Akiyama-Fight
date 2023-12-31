extends StateMachine
@export var id = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	add_state('STAND')
	add_state('RUN')
	add_state('WALK')
	add_state('CROUCH')
	add_state('JUMP_SQUAT')
	add_state('HOP')
	add_state('NORMAL_JUMP')
	add_state('HYPER_HOP')
	add_state('SUPER_JUMP')
	add_state('AIR')
	add_state('LANDING')
	call_deferred("set_state", states.STAND)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(delta):
	parent.move_and_slide()
	if Landing() == true:
		parent._frame()
		return states.LANDING
	if Falling() == true:
		print("falling")
		return states.AIR
	parent.states.text = str(state)
	match state:
		states.STAND:
			if ((Input.get_action_strength("right_%s" % id) == 1) && (Input.get_action_strength("left_%s" % id) == 0)):
				parent.velocity.x = parent.RUNSPEED
				parent._frame()
				parent.turn(false)
				return states.WALK
			elif ((Input.get_action_strength("right_%s" % id) == 0) && (Input.get_action_strength("left_%s" % id) == 1)):
				parent.velocity.x = -parent.RUNSPEED
				parent._frame()
				parent.turn(false)
				return states.WALK
			if parent.velocity.x > 0 and state == states.STAND:
				parent.velocity.x = 0
			elif parent.velocity.x < 0 and state == states.STAND:
				parent.velocity.x = 0
			if (Input.get_action_strength("jump_%s" % id) == 1):
				parent._frame()
				return states.JUMP_SQUAT
		
		states.JUMP_SQUAT:
			if parent.frame == parent.jump_squat:
				if not Input.is_action_pressed("jump_%s" % id):
					parent._frame()
					jump_direction()
					return states.HOP
				else:
					parent._frame()
					jump_direction()
					return states.NORMAL_JUMP
		
		states.HOP:
			parent.velocity.y = -parent.HOPFORCE
			parent._frame()
			return states.AIR
		
		states.NORMAL_JUMP:
			parent.velocity.y = -parent.JUMPFORCE
			parent._frame()
			return states.AIR
				
		states.AIR:
			parent.velocity.y += parent.GRAVITY * delta
			AIRMOVEMENT()
		
		states.WALK:
			if (Input.get_action_strength("jump_%s" % id) == 1):
				parent._frame()
				return states.JUMP_SQUAT
			if Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent._frame()
				parent.velocity.x = -parent.WALKSPEED
			elif Input.is_action_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent._frame()
				parent.velocity.x =parent.WALKSPEED
			else:
				return states.STAND
		states.RUN:
			pass
		states.CROUCH:
			pass
		states.LANDING:
			#parent.velocity.y = 0
			#if parent.frame <= parent.landing_frames + parent.lag_frames:
				#if (Input.get_action_strength("jump_%s" % id) == 1):
					#parent._frame()
					#return states.JUMP_SQUAT
			#else:
			if Input.is_action_pressed("down_%s" % id):
				parent.lag_frames = 0
				parent._frame()
				return states.CROUCH
			elif (Input.get_action_strength("jump_%s" % id) == 1):
				parent._frame()
				return states.JUMP_SQUAT
			else:
				parent.lag_frames = 0
				parent._frame()
				return states.STAND
			parent.lag_frames = 0

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func state_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false

func jump_direction():
	if Input.is_action_pressed("left_%s" % id):
		parent.velocity.x = -parent.WALKSPEED
	elif Input.is_action_pressed("right_%s" % id):
		parent.velocity.x = parent.WALKSPEED

func Landing():
	if state_includes([states.AIR]):
		if (parent.Ground.is_colliding()) and parent.velocity.y >= 0:
			var collider = parent.Ground.get_collider()
			parent.frame = 0
			if parent.velocity.y > 0:
				parent.velocity.y = 0
			return true

func Falling():
	if state_includes([states.STAND,states.WALK,states.JUMP_SQUAT,states.RUN,states.CROUCH]):
		if (not parent.Ground.is_colliding()):
			return true
func AIRMOVEMENT():
	pass
	

