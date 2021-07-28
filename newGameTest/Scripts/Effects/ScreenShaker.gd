extends Node

var amplitude = 0
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
onready var CamOGrot = Vector3()
var count = 0
var time_expl = 0.5
var amp_expl = 0.015
var done = 0

onready var camera = get_parent()

func _ready():
	set_process(false)

func start(duration=0.2, frequency=15, amplitude=0.015):
	self.amplitude = amplitude
	
	$Duration.wait_time = duration
	$Frequency.wait_time = 1 / float(frequency)
	$Duration.start()
	$Frequency.start()
	
	#_new_shake()
	set_process(true)
	
func _process(delta):
	var rand = Vector3()
	self.CamOGrot.x = camera.translation.x
	self.CamOGrot.y = camera.translation.y
	self.CamOGrot.z = camera.translation.z
	var amount = self.amplitude + (0.01*self.count)
	rand.x = CamOGrot.x + rand_range(-amount, amount)
	rand.z = CamOGrot.z	+ rand_range(-amount*0.25, amount*0.25)
	rand.y = clamp(CamOGrot.y + rand_range(-amount, amount), 0.7, 0.9)
	
	$TweenShake.interpolate_property(camera, "translation", camera.translation, rand, $Frequency.wait_time, TRANS, EASE)
	$TweenShake.start()

func _on_Frequency_timeout():
	$TweenShake.interpolate_property(camera, "translation", camera.translation, CamOGrot, $Frequency.wait_time, TRANS, EASE)
	$TweenShake.start()
	pass

func _on_Duration_timeout():
	self.time_expl += 0.18
	self.amp_expl += 0.07
	self.amplitude += 0.075
	start(time_expl, 15, amp_expl)

func _wakeup():
	#camera.rotation_degrees.z = -90.0
	#camera.translation.y = 0.25
	var rand = Vector3()
	var transl = Vector3()
	rand.x = camera.rotation_degrees.x
	rand.y = camera.rotation_degrees.y
	rand.z = camera.rotation_degrees.z + 30.0
	transl.x = camera.translation.x
	transl.y = camera.translation.y + 0.25
	transl.z = camera.translation.z
	
	$TweenShake.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees, rand, $Timer.wait_time, TRANS, EASE)
	$TweenShake.interpolate_property(camera, "translation", camera.translation, transl, $Timer.wait_time, TRANS, EASE)
	$TweenShake.start()
	$Timer.start()

func _on_Timer_timeout():
	if self.done == 0:
		$Timer2.start()
		print("done")
	if self.done == 1:
		#DataManager.player_play()
		$Timer.one_shot = true
		self.done = 2

func _on_Timer2_timeout():
	if self.done == 1:
		return
	$Timer.wait_time = 2.5
	var rand = Vector3()
	var transl = Vector3()
	rand.x = camera.rotation_degrees.x
	rand.y = camera.rotation_degrees.y
	rand.z = camera.rotation_degrees.z + 60.0
	transl.x = camera.translation.x
	transl.y = camera.translation.y + 0.5
	transl.z = camera.translation.z
	
	$TweenShake.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees, rand, $Timer.wait_time, TRANS, EASE)
	$TweenShake.interpolate_property(camera, "translation", camera.translation, transl, $Timer.wait_time, TRANS, EASE)
	$TweenShake.start()
	self.done = 1
	$Timer.start()
