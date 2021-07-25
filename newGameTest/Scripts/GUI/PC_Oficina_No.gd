extends Control

var animReady

func _ready():
	$Texto/Anim.play("items")
	animReady = false

func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if animReady==false:
			$Texto/Anim.advance(5)
		else:
			DataManager.player_play()
			DataManager.remove_unique_HUD(self)

func _on_Anim_animation_finished(anim_name):
	animReady=true
