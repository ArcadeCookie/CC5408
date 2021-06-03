extends Control

onready var _transition_rect := $FadeIn
onready var GameIntro := $GameIntro
onready var Audio := $AudioStreamPlayer
#onready var tween_out = get_node("Tween")

#export var transition_duration = 1.00
#export var transition_type = 1 # TRANS_SINE

# Called when the node enters the scene tree for the first time.
func _ready():
	var newgame = $Menu/HBoxContainer/Buttons/NewGameButton
	newgame.connect("pressed", self, "_on_NewGameButton_pressed")
	
#
func _on_NewGameButton_pressed():
	_transition_rect.transition_to()


func _on_FadeIn_readyFadeIn():
	#GameIntro.intro("res://Scenes/Map/Mapa1.tscn")
	GameIntro.intro()


func _on_GameIntro_readyGameIntro():
	self.hide()
	get_tree().change_scene("res://Scenes/Map/Mapa1.tscn")
	#fade_out(Audio)
	#pass # Replace with function body.

#func fade_out(stream_player):
	# tween music volume down to 0
	#tween_out.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	#tween_out.start()
	# when the tween ends, the music will be stopped

#func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
#	object.stop()
#	object.volume_db = 0 # reset volume
#	get_tree().change_scene("res://Scenes/Map/Mapa1.tscn")
	
	
	
	
