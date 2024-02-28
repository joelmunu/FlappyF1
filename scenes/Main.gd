extends Node

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$Reset.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	generate_pipes()
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
						check_top()
		if Input.is_action_just_pressed("ui_accept"):
			if game_running == false:
					start_game()
			else:
				if $Player.flying:
					$Player.flap()
					check_top()
						
func start_game():
	game_running = true
	$Player.flying = true
	$Player.flap()
	$PipeTimer.start()	

func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2  + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(player_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)
	
func check_top():
	if $Player.position.y < 0:
		$Player.falling = true
		$AudioStreamPlayer2D.play()
		stop_game()
		
func player_hit():
	$Player.falling = true
	$AudioStreamPlayer2D.play()
	stop_game()
	
func stop_game():
	$PipeTimer.stop()
	$Player.flying = false
	game_running = false
	game_over = true
	$Reset.show()
	
func _on_ground_body_entered(body):
	$Player.falling = false
	$AudioStreamPlayer2D.play()
	stop_game()


func _on_reset_restart():
	new_game()

