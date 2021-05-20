extends ColorRect

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	pass
	# Plays the animation backward to fade in
	#_anim_player.play_backwards("fade_in")
func fade_out() -> void:
	_anim_player.play("fade_out")
	yield(_anim_player, "animation_finished")
	self.hide()

func transition_to(_next_scene := next_scene_path) -> void:
	# Plays the Fade animation and wait until it finishes
	self.show()
	_anim_player.play("fade_in")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	get_tree().change_scene(_next_scene)
	self.hide()
