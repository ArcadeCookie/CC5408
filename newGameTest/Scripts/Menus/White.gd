extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var done = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if done == 0:
		_showit()
		done = 1
	
	## aca agregar cambio de mundo
func _showit():
	var _animplayer = $ColorRect/AnimationPlayer
	_animplayer.play("white")
	yield(_animplayer, "animation_finished")
	DataManager.send_msg("change")
	DataManager.remove_HUD(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
