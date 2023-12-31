extends CharacterBody2D

var frame = 0
var dash_duration = 10

# Air variable. Jumps in games like KOF are considered a short hop if held under
# 4 frames, and normal jumps if >= 5 frames
var jump_squat = 4
var landing_frames = 0
var lag_frames = 0

@onready var Ground = get_node('Raycasts/Ground')

var RUNSPEED = 340
var DASHSPEED = 390
var WALKSPEED = 420
var GRAVITY = 5500
var HOPFORCE = 1300
var JUMPFORCE = 2000
var MAXAIRSPEED = 300
var AIR_ACCEL = 25
var FALLSPEED = 60
var FALLINGSPEED = 900
var MAXFALLSPEED = 900
var TRACTION = 40
var ROLL_DISTANCE = 350
var air_dodge_speed = 500
var UP_B_LAUNCHSPEED = 700
var left_side = true

@onready var states = $State


func updateframes(delta):
	frame += 1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)

func _frame():
	frame = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _physics_process(delta):
	$Frames.text = str(frame)
	

