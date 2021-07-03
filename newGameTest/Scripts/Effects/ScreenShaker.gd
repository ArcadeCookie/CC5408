extends Node

var amplitude = 0
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
onready var CamOGrot = Vector3()
var count = 0

onready var camera = get_parent()

func start(duration=1.0, frequency=15, amplitude=10.15):
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
	_reset()
	#if self.count==7:
	$Frequency.stop()
