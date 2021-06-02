extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Reference to the _AnimationPlayer_ node
onready var _anim_player := $CenterContainer/Text1/AnimationPlayer
#onready var music = $"./OST"
#onready var CorrectSound = preload("res://Resources/Music/Music.wav")

# Called when the node enters the scene tree for the first time.
func _ready():	
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
	self.hide()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
