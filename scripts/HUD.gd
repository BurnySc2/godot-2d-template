extends CanvasLayer

signal start_game
export var wait_time = 2
export var button_show_delay = 1

func show_message(text: String):
	$Message.text = text
	$Message.show()

func hide_message():
	$Message.hide()
	
func show_game_over():
	show_message("Game Over")
	# Wait 2 seconds
	yield(get_tree().create_timer(wait_time), "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(button_show_delay), "timeout")
	$StartButton.show()

func update_score(score: int):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
