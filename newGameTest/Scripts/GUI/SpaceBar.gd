extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var showing

# Called when the node enters the scene tree for the first time.
func _ready():
	showing = 1

func _play():
	$AnimationPlayer.play("SpaceShow")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SpaceShow":
		$AnimationPlayer.play("Space")
	else:
		if showing == 1:
			$AnimationPlayer.play("Space")
