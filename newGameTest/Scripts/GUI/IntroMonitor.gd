extends Spatial

onready var Terminal = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _activate():
	var _animplayer = $Viewport/Node2D/Commence/AnimationPlayer
	## Muestra el inicio de la data/info y el texto de comenzar
	# ------------------------------------------------------------------------
	$Viewport/Node2D/ExpData.show()
	$Viewport/Node2D/ExpInfo.show()
	$Viewport/Node2D/Commence.show()
	_animplayer.play("Begin")
	yield(_animplayer, "animation_finished")
	$Viewport/Node2D/Yes.show()
	_animplayer.play("Stop")
	## begin the experiment: yes || 
	# ------------------------------------------------------------------------
	yield(_animplayer, "animation_finished")
	$Viewport/Node2D/Commence.hide()
	$Viewport/Node2D/Yes.hide()
	# ------------------------------------------------------------------------
	## now, some changes to ExpData (change some numbers)
	_animplayer = $Viewport/Node2D/ExpData/AnimationPlayer
	_animplayer.play("text1")
	yield(_animplayer, "animation_finished")
	# ------------------------------------------------------------------------
	## wait like 2 seconds, then show warning msg below
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
	# ------------------------------------------------------------------------
	## $Viewport/Node2D/Warning2.hide()
	## esto es justo despues de que dice "warning" y oculta el mensaje
	## de advertencia
	## ahora deberia mostrarse el primer sprite de experimento (un rayo?)
	## nuevamente otro cambio a los numeros de ExpData
	Terminal.beginexp()
	_animplayer = $Viewport/Node2D/ExpData/AnimationPlayer
	_animplayer.play("text2")
	yield(_animplayer, "animation_finished")
	# ------------------------------------------------------------------------
	## pasan 4-5 segundos y muestra warning rojo
	$Viewport/Node2D/Warning.show()
	_animplayer = $Viewport/Node2D/Warning/AnimationPlayer
	_animplayer.play("show")
	yield(_animplayer, "animation_finished")
	Terminal.error1() ## sprite 1
	# ------------------------------------------------------------------------
	## error 1 maquina, incrementan los numeros de nuevo
	_animplayer = $Viewport/Node2D/ExpData/AnimationPlayer
	_animplayer.play("text3")
	yield(_animplayer, "animation_finished")
	Terminal.error2() ## sprite 2
	# ------------------------------------------------------------------------
	## error 2 maquina
	_animplayer.play("text4")
	yield(_animplayer, "animation_finished")
	Terminal.error3() ## sprite 3 + explosion bola
	## aca agregar alguna reproduccion de sonido o algo con send_msg
	## nuevamente los numeros empiezan a cambiar pero se van a rojo y que tengan !!!
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
