extends StateMachine
@export var id = 1

func _ready():
	add_state('STAND')
	add_state('JUMP')
	add_state('DASH')
	add_state('WALK')
	add_state('CROUCH')
	call_deferred("set_state", states.STAND)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(delta):
	parent.move_and_slide()
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
		states.JUMP:
			pass
		states.WALK:
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
		states.DASH:
			pass
		states.CROUCH:
			pass

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func state_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false
