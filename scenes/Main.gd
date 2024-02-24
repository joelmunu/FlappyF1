extends Node

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

func _ready():
	new_game()
	
func new_game():
	#reset variables
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$Player.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Player.flying:
						$Player.flap()
						
func start_game():
	game_running = true
	$Player.flying = true
	$Player.flap()