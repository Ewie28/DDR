extends CanvasLayer
@onready var margin_container = $MarginContainer
@onready var label = $MarginContainer/MarginContainer/HBoxContainer/Label


func _ready() -> void:
	hide_textbox()
	update_mission_status()
	Signals.DayAdvanced.connect(_on_day_advanced) # Reset when new day starts
	follow_viewport_enabled = true  

func hide_textbox():
	label.text = ""
	margin_container.hide()
	
func show_textbox():
	margin_container.show()
	
func add_text(next_text):
	label.text = next_text
	show_textbox()

# Updates the displayed mission count
func update_mission_status():
	var mission_text = "%d/%d odd jobs done" % [Signals.missions_attempted, Signals.MAX_MISSIONS]
	add_text(mission_text)
	
	# Resets the mission display when entering the bedroom
func reset_mission_status():
	Signals.missions_attempted = 0
	update_mission_status()
	
# Handles scene visibility logic
func _process(_delta):
	if Signals.current_scene == "outside":
		show_textbox()
		update_mission_status()
	elif Signals.current_scene == "bedroom":
		hide_textbox()
		reset_mission_status()
	elif Signals.current_scene == "rhythm":
		hide_textbox()  # Hide, but don't reset
		
# Reset missions attempted when a new day starts
func _on_day_advanced():
	add_text("0/3 missions completed")
