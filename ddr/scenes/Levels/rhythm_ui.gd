extends Control

var score: int = 0

# Called when node enters scene tree for first time
func _ready():
	Signals.IncrementScore.connect(IncrementScore)

func IncrementScore(incr: int):
	score +=incr
	%ScoreLabel.text = str(score) + "pts"
