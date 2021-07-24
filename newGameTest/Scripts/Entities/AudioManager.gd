extends Node

onready var Game = get_tree().get_root().get_node("Game")
onready var MusicStream = Game.get_node("MusicStreamPlayer")

var track_loaded = false

func play_music():
	if track_loaded:
		MusicStream.play()


func change_track(track_route):
	MusicStream.set_stream(track_route)
	if not track_loaded:
		track_loaded = true
	play_music()


func stop_music():
	MusicStream.stop()


func play_FX(sound_route):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.stream(sound_route)
	audio_stream_player.set_script("res://Scripts/Entities/FXAudioStream.gd")
	Game.add_child(audio_stream_player)
	audio_stream_player.play()


func on_fx_finished(audio_stream):
	audio_stream.queue_free()
