extends Node2D

export (PackedScene) var Mob
# How often mobs spawn
export var mob_spawn_interval = 0.5
# Value 0 < x <= 1, where 1 is same difficult but <1 is increasing difficulty over time 
export var difficulty = 0.99
export var game_start_delay = 1.5

var game_running = false
var score = 0
var score_timer = 0
var mob_time = 0

func _ready():
	randomize()
#	new_game()

func _process(delta: float):
	if not game_running:
		return
		
	$HUD.hide_message()
	score_timer += delta
	if score_timer > 1:
		score_timer -= 1
		score += 1
		$HUD.update_score(score)
		
	mob_time += delta
	if mob_time > mob_spawn_interval * pow(difficulty, score):
		mob_time -= mob_spawn_interval * pow(difficulty, score)
		spawn_mob()

func new_game():
	# Reset the game: remove enemies, play music, set score to 0, set player position
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$Music.play()
	score = 0
	$HUD.show_message("Get Ready")
	$HUD.update_score(score)
	score_timer = 0
	mob_time = 0
	
	# Wait start_delay seconds
	yield(get_tree().create_timer(game_start_delay), "timeout")
	game_running = true

func game_over():
	game_running = false
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()

func spawn_mob():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_HUD_start_game():
	new_game()
