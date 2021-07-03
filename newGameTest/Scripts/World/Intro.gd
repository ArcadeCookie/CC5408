extends Spatial

var presented = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if presented==0:
		DataManager.call_HUD("res://Scenes/GUI/IntroTextCtrl.tscn")

func signalR(sig):
	if sig == "move":
		$KinematicBody.changespeed() ## cambia la velocidad del jugador


func _on_Monitor_activateMenu():
	DataManager.call_HUD("res://Scenes/GUI/NumericPanel.tscn")
