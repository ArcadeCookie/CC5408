extends Control

onready var LabelH = $Label
onready var AnimPlayer = $Label/AnimationPlayer
onready var RichLabel = $RichTextLabel
onready var RichAnimPlayer = $RichTextLabel/AnimationPlayer2
var playing
var readyA
var textnum
var newtext
var itemMissing
signal done

func _ready():
	AnimPlayer.play("showText")
	playing = true
	readyA = false
	itemMissing = false
	textnum = 0

func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if playing==true:
			AnimPlayer.advance(5)
		elif playing==false and readyA==true:
			AnimPlayer.stop(true)
			LabelH.hide()
			#LabelH.text = newtext
			#LabelH.show()
			if textnum >= 4: # indicacion maquina
				RichLabel.show()
				RichLabel.bbcode_text = newtext
				RichAnimPlayer.play("items")
				#yield(RichAnimPlayer, "animation_finished")
				#DataManager.remove_HUD(self)
				#if textnum == 5:
				#	RichLabel.hide()
				#	emit_signal("done")
			else:
				LabelH.text = newtext
				LabelH.show()
				playing = true
				AnimPlayer.play("showText")
			readyA=false

func _on_AnimationPlayer_animation_finished(anim_name):
	playing = false	
	textnum += 1
	if textnum == 1:
		newtext = "After all that effort and now just being a\n supporter, I thought you were going to have\n a grudge towards Dr.X or the project."
	elif textnum == 2:
		newtext = "\n But here we are, about to witness a huge step\n for mankind and it's all thanks to you."
	elif textnum == 3:
		newtext = "\n Imagine being the one starting up the machine, \n I envy you. You better hurry up, it's starting soon!"
	elif textnum == 4:
		newtext = "\n Go and activate the [color=#209f88]machine[/color]."
		## this was added
	#elif textnum == 5:
	#	emit_signal("done")
	readyA=true

func _on_AnimationPlayer2_animation_finished(anim_name):
	playing = false	
	textnum += 1
	#if textnum == 5:
	#	emit_signal("done")
	#readyA=true
	
func missing_card():
	newtext = "\n You're missing your [color=#209f88]card[/color]. \n Go to your office and find it."
	itemMissing = true
	RichLabel.show()
	RichLabel.bbcode_text = newtext
	RichAnimPlayer.play("items")
