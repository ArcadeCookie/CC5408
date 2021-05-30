extends Node

const FILE_NAME = "res://Data/game-data.json"

var State = {
	"Player" : {},
	"Special_Objects" : {},
	"Terminals" : {},
	"D1" : {},
	"D2" : {},
	"D3" : {} 
}

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(State))
	file.close()

func load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			State = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
