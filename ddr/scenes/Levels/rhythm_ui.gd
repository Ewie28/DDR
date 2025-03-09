extends Control

var score: int = 0
var pass_threshold: int = 25000 

# Called when node enters scene tree for first time
func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.EndRhythmGame.connect(_on_rhythm_game_ended)

func IncrementScore(incr: int):
	score += incr
	%ScoreLabel.text = str(score) + "pts"
	
# Reset the score for a new game
func reset_score():
	score = 0
	%ScoreLabel.text = "0pts"

# When we receive the end game signal, report our final score
func _on_rhythm_game_ended(success):
	print("(rhythmUI)RhythmUI final score: " + str(score))
	print("Result: " + ("PASS" if score >= pass_threshold else "FAIL"))
	
	# Emit our own signal with the detailed results
	Signals.RhythmGameResult.emit(score, score >= pass_threshold)
