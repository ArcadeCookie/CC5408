extends Control

func _ready():
	$Texto/Anim.play("items")

func _on_Anim_animation_finished(anim_name):
	DataManager.remove_unique_HUD(self)
