extends ColorRect

export(String, FILE, "*.tscn") var next_scene_path

onready var _anim_player := $AnimationPlayer
signal readyFadeIn

func _ready() -> void:
	pass
	
func fade_out() -> void:
	_anim_player.play("fade_out")
	yield(_anim_player, "animation_finished")
	self.hide()

func transition_to(_next_scene := next_scene_path) -> void:
	self.show()
	_anim_player.play("fade_in")
	yield(_anim_player, "animation_finished")
	emit_signal("readyFadeIn")
