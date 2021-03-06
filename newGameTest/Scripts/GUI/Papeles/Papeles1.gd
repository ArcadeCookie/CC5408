extends Control

onready var actual_page = $Page1
var page_num

# Called when the node enters the scene tree for the first time.
func _ready():
	page_num = 1

func _change_page():
	var next_page
	if page_num == 1:
		next_page = $Page1
	elif page_num == 2:
		next_page = $Page2
	AudioManager.play_FX("res://Resources/Sounds/pageturn.wav")
	next_page.show()
	actual_page.hide()
	actual_page = next_page
	
func _on_PreviousPage_pressed():
	if page_num > 1:
		page_num -= 1
		_change_page()


func _on_NextPage_pressed():
	if page_num < 2:
		page_num += 1
		_change_page()

func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#AudioManager.fade_music(2.0)
	#AudioManager.fade(9)
	DataManager.player_play()
	DataManager.remove_unique_HUD(self)
