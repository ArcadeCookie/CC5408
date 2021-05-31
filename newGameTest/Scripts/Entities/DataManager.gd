extends Node

# Variable to store the path in wich the data is stored
const FILE_NAME = "res://Data/game-data.json"

# Structure-like object on which the data is stored
var State = {
	# Dictionary for player position
	"Player" : {},
	
	# Dictionary for special objects positions
	"Special_Objects" : {},
	
	# Dictionary for terminals states
	"Terminals" : {},
	
	# Dictionary to store the information of every object in every dimension
	"D1" : {},
	"D2" : {},
	"D3" : {} 
	
	# At the moment is strictly necesary this structure in order to the correct execution of the game
	# in scenes DemoMap1, DemoMap2 and DemoMap3.
}


# This method will store the current state of the game in the specified file
func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(State))
	file.close()


# This method will read the specified file and build a state-like structured as describe previously
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
