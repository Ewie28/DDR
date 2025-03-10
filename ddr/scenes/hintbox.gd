extends Control
@onready var hint_box = $CanvasLayer/Textbox
@onready var hint_text = $CanvasLayer/Textbox/RichTextLabel
@onready var ding_sound = $DingSfx

func _ready():
	hint_text.text = "test tes tes te s test "

func show_hint(text_message: String) -> void:
	# Set the text
	hint_text.text = text_message
	
	# Make the hint box visible
	hint_box.visible = true
	ding_sound.play()
	
	# Create a timer to hide the hint box
	var timer = get_tree().create_timer(5.0)
	timer.timeout.connect(destroy_hint)

func destroy_hint() -> void:
	# Destroy the hint box instance
	hint_box.visible = false
