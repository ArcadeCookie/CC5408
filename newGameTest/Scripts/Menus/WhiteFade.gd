extends ColorRect


func _ready() -> void:
	_showit()
	
	## aca agregar cambio de mundo
func _showit():
	var _animplayer = $AnimationPlayer
	_animplayer.play("white")
	yield(_animplayer, "animation_finished")
	DataManager.change_to_specific_map("1")
	_animplayer.play("whiteout")
	yield(_animplayer, "animation_finished")
	DataManager.remove_HUD(self)
