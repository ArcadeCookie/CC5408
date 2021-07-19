extends Node

var amplitude = 0
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
onready var CamOGrot = Vector3()
var count = 0
var time_expl = 1.0
var amp_expl = 3.0
var done = 0

onready var camera = get_parent()

func start(duration=1.0, frequency=15, amplitude=2.0):
	self.amplitude = amplitude
	
	$Duration.wait_time = duration
	$Frequency.wait_time = 1 / float(frequency)
	$Duration.start()
	$Frequency.start()
	
	_new_shake()

func _new_shake():
	var rand = Vector3()
	self.CamOGrot.x = 0+ camera.rotation_degrees.x
	self.CamOGrot.y = 0+ camera.rotation_degrees.y
	self.CamOGrot.z = 0+ camera.rotation_degrees.z
	var amount = self.amplitude + (0.05*self.count)
	rand.x = CamOGrot.x + rand_range(-amount, amount)
	rand.y = CamOGrot.y + rand_range(-amount, amount)
	rand.z = CamOGrot.z + rand_range(-amount, amount)
	#rand.x = rand_range(-amplitude, amplitude)
	#rand.y = rand_range(-amplitude, amplitude)
	#rand.z = rand_range(-amplitude, amplitude)
	
	$TweenShake.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees, rand, $Frequency.wait_time, TRANS, EASE)
	$TweenShake.start()

func _reset():
	#self.count += 1
	#print(self.count)
	#if self.count == 7:
	camera.rotation_degrees = self.CamOGrot
	#pass
	$TweenShake.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees, Vector3(), $Frequency.wait_time, TRANS, EASE)
	$TweenShake.start()

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	self.time_expl += 0.1
	self.amp_expl += 0.4
	start(time_expl, 15, amp_expl)
	#_reset()
	#if self.count==7:
	#$Frequency.stop()

func _wakeup():
	camera.rotation_degrees.z = -90.0
	camera.translation.y = 0.25
	var rand = Vector3()
	var transl = Vector3()
	rand.x = camera.rotation_degrees.x
	rand.y = camera.rotation_degrees.y
	rand.z = camera.rotation_degrees.z + 30.0
	transl.x = camera.translation.x
	transl.y = camera.translation.y + 0.25
	transl.z = camera.translation.z
	
	$TweenShake.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees, rand, $Timer.wait_time, TRANS, EASE)
	#$TweenShake.start()
	$TweenShake.interpolate_property(camera, "translation", camera.translation, transl, $Timer.wait_time, TRANS, EASE)
	$TweenShake.start()
	$Timer.start()

func _on_Timer_timeout():
	if self.done == 0:
		$Timer2.start()
		#self.done = 1
		print("done")

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
