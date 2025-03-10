extends Sprite2D

@onready var quest_text = $questText
@onready var pass_sfx = $PassSFX
@onready var fail_sfx = $FailSFX

func _ready():
	# Hide the textbox initially
	visible = false
	quest_text.text = ""
	
	# Connect to the necessary signals
	Signals.RhythmGameResult.connect(_on_rhythm_game_result)
	Signals.EndRhythmGame.connect(_on_rhythm_game_ended)

func _on_rhythm_game_result(score: int, success: bool):
	# Get the current level from the RhythmGameManager
	var rhythm_game_manager = get_node("../RhythmGameManager")
	if rhythm_game_manager != null and rhythm_game_manager.current_level != "":
		var level_id = rhythm_game_manager.current_level
		
		if level_id in rhythm_game_manager.levels:
			var level_data = rhythm_game_manager.levels[level_id]
			
			# Set the appropriate text based on success
			if success and "win_text" in level_data:
				quest_text.text = level_data.win_text
				pass_sfx.play()
			elif not success and "lose_text" in level_data:
				quest_text.text = level_data.lose_text
				fail_sfx.play()
			else:
				quest_text.text = "Level " + (level_data.title if "title" in level_data else level_id) + \
								 " " + ("completed!" if success else "failed!")
			
			# Show the textbox
			print("TEXT in textbox" + quest_text.text)
			visible = true

func _on_rhythm_game_ended(_success):
	# Hide the textbox when the game completely ends
	visible = false
