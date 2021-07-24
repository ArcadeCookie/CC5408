extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var newgame = $Menu/HBoxContainer/Buttons/NewGameButton
	newgame.connect("pressed", self, "_on_NewGameButton_pressed")
	$ScreenChanger.play("titlescreen")
	AudioManager.change_track("res://Resources/Music/testjuego1.wav")
	AudioManager.play_music()
#
func _on_NewGameButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DataManager.call_HUD("res://Scenes/Map/NewGameIntro.tscn")
	DataManager.remove_HUD(self)


func _on_ScreenChanger_animation_finished(anim_name):
	$ScreenChanger.play("titlescreen")
