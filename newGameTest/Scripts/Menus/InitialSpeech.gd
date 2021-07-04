extends ColorRect

onready var _anim_player := $CenterContainer/Text1/AnimationPlayer

func _ready():	
	intro()
		
func intro():
	self.show()
	#_anim_player = $CenterContainer/Text1/AnimationPlayer
	#_anim_player.play("show")
	#yield(_anim_player, "animation_finished")
	#_anim_player = $CenterContainer/Text2/AnimationPlayer
#	_anim_player.play("show")
	#yield(_anim_player, "animation_finished")
	#_anim_player = $CenterContainer/Text3/AnimationPlayer
	#_anim_player.play("show")
	#yield(_anim_player, "animation_finished")
	#_anim_player = $AnimationPlayer
	#_anim_player.play("fadeout")
	#yield(_anim_player, "animation_finished")
	DataManager.remove_HUD(self)
	DataManager.send_msg("ready")
