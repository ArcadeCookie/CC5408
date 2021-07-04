extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal machineError

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _activate():
	var _animplayer = $Viewport/Node2D/Commence/AnimationPlayer
	## Muestra el inicio de la data/info y el texto de comenzar
	$Viewport/Node2D/ExpData.show()
	$Viewport/Node2D/ExpInfo.show()
	$Viewport/Node2D/Commence.show()
	_animplayer.play("Begin")
	yield(_animplayer, "animation_finished")
	$Viewport/Node2D/Yes.show()
	_animplayer.play("Stop")
	## le da un segundo para que desaparezcan
	yield(_animplayer, "animation_finished")
	$Viewport/Node2D/Commence.hide()
	$Viewport/Node2D/Yes.hide()
	_animplayer = $Viewport/Node2D/Warning2/AnimationPlayer
	_animplayer.play("Warning")
	yield(_animplayer, "animation_finished")
	_animplayer = $Viewport/Node2D/Proceed/AnimationPlayer
	_animplayer.play("text")
	yield(_animplayer, "animation_finished")
	$Viewport/Node2D/Yes.show()
	_animplayer.play("stop")
	yield(_animplayer, "animation_finished")
	$Viewport/Node2D/Yes.hide()
	$Viewport/Node2D/Proceed.hide()
	$Viewport/Node2D/Warning2.hide()
	### muestra warning rojo
	_animplayer = $Viewport/Node2D/Warning/AnimationPlayer
	_animplayer.play("show")
	yield(_animplayer, "animation_finished")
	emit_signal("machineError")
	## aca agregar alguna reproduccion de sonido o algo
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
