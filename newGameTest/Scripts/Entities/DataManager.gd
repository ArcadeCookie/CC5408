extends Node

onready var Game = get_tree().get_root().get_node("Game")

# Variable to store the path in wich the data is stored
const FILE_NAME = "res://Data/game-data.json"

var random = RandomNumberGenerator.new()

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
	"D3" : {},
	
	# At the moment is strictly necesary this structure in order to the correct execution of the game
	# in scenes DemoMap1, DemoMap2 and DemoMap3.
	
	"Available_Dimensions" : ["1", "2"],
	"Disabled_Dimensions" : [],
	"Current_Dimension" : "1"
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


func change_map() -> void:
	get_tree().call_group("object", "on_change_map")
	random.randomize()
	var dimensions_available = State.Available_Dimensions.duplicate(true)
	dimensions_available.erase(State.Current_Dimension)
	var new_dimension_id = random.randi_range(0,dimensions_available.size()-1)
	var new_dimension = dimensions_available[new_dimension_id]
	State.Current_Dimension = new_dimension
	
	# DONT FORGET TO CHANGE FOR NEW MAPs, CUZ ITS KINDA HARCODED
	Game.change_scene("res://Scenes/Demo/DemoMap" + new_dimension + ".tscn")


func change_to_specific_map(scene_id):
	get_tree().call_group("object", "on_change_map")
	State.Current_Dimension = scene_id
	Game.change_scene("res://Scenes/Demo/DemoMap" + scene_id + ".tscn")


func call_HUD(scene):
	Game.call_HUD(scene)


func remove_HUD(scene_node):
	Game.remove_HUD(scene_node)


func removeScenes():
	Game.removeScenes()


func enable_dimension(dimension : String) -> void:
	if not dimension in State.Available_Dimensions and not dimension in State.Disabled_Dimensions:
		State.Available_Dimensions.append(dimension)


func disable_dimension(dimension : String) -> void:
	State.Available_Dimensions.erase(dimension)
	if not dimension in State.Disabled_Dimensions:
		State.Disabled_Dimensions.append(dimension)
