extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DataManager.call_unique_HUD("res://Scenes/GUI/NewDimText.tscn")
	DataManager.camera_stop()
	DataManager.player_stop()
	var world = get_parent()
	world.get_node("Player/Camera").rotation_degrees.z = -90.0
	world.get_node("Player/Camera").translation.y = 0.25
	$Timer.start()

func _on_Timer_timeout():
	#pass
	var world = get_parent()
	world.get_node("Player/Camera/ScreenShaker")._wakeup()
