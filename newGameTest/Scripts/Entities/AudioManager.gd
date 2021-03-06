extends Node

onready var Game = get_tree().get_root().get_node("Game")
onready var MusicStream = Game.get_node("MusicStreamPlayer")

var fading = false
var fade_intensity = 1
var track_loaded = false

func play_music():
	if track_loaded:
		MusicStream.volume_db = -15.0
		MusicStream.play()


func change_track(track_route):
	MusicStream.set_stream(load(track_route))
	if not track_loaded:
		track_loaded = true

func _process(delta):
	if fading:
		MusicStream.volume_db -= delta*fade_intensity
		if MusicStream.volume_db < -79.0:
			fading = false

func fade(intensity):
	fading = true
	fade_intensity = intensity

func stop_music():
	MusicStream.stop()

func play_FX(sound_route):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.set_stream(load(sound_route))
	audio_stream_player.set_script(load("res://Scripts/Entities/FXAudioStream.gd"))
	Game.add_child(audio_stream_player)
	audio_stream_player.play()


func on_fx_finished(audio_stream):
	audio_stream.queue_free()
