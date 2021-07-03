extends Control

onready var RichLabel = $RichTextLabel
onready var RichAnimPlayer = $RichTextLabel/AnimationPlayer2

func _ready():
	RichLabel.show()
	RichLabel.bbcode_text = "\n You're missing your [color=#209f88]card[/color]. \n Go to your office and find it."
	RichAnimPlayer.play("items")
	yield(RichAnimPlayer, "animation_finished")
	DataManager.remove_HUD(self)
