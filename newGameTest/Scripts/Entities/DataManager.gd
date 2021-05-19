extends Node

const FILE_NAME = "res://Data/game-data.json"

var state = {
	"player" : {
		"translation" : Vector3(),
		"rotation" : Vector3()
	},
	"terminals" : {
		"test_door" : false
	},
	"dim_1" : {
		"test_object" : {
			"translation" : Vector3(),
			"rotation" : Vector3()
		} 
	},
	"dim_3" : {
		"test_object" : {
			"translation" : Vector3(),
			"rotation" : Vector3()
		} 
	}
}

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(state))
	file.close()

func load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			state = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
