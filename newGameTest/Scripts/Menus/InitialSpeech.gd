extends ColorRect

onready var _anim_player := $CenterContainer/Text1/AnimationPlayer
export(String, FILE, "*.tscn") var next_scene_path
signal readyGameIntro

func _ready():	
	pass
		
func intro(_next_scene := next_scene_path):
	self.show()
	_anim_player = $CenterContainer/Text1/AnimationPlayer
	_anim_player.play("show")
	yield(_anim_player, "animation_finished")
	_anim_player = $CenterContainer/Text2/AnimationPlayer
	_anim_player.play("show")
	yield(_anim_player, "animation_finished")
	_anim_player = $CenterContainer/Text3/AnimationPlayer
	_anim_player.play("show")
	yield(_anim_player, "animation_finished")
	_anim_player = $AnimationPlayer
	_anim_player.play("fadeout")
	yield(_anim_player, "animation_finished")
	#_anim_player = $"./AudioStreamPlayer"
	self.hide()
	emit_signal("readyGameIntro")
	#get_tree().change_scene(_next_scene)	
