extends ColorRect

var done = 0

func _ready():
	if done == 0:
		_showit()
		done = 1
	
	## aca agregar cambio de mundo
func _showit():
	var _animplayer = $AnimationPlayer
	_animplayer.play("white")
	yield(_animplayer, "animation_finished")
	DataManager.send_msg("change")
	DataManager.remove_HUD(self)
