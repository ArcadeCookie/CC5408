extends "res://Scripts/Entities/Enemy2.gd"
# Specific instance of an Enemy object
# Hierarchy: This -> Enemy -> Node -> ...


# Exectuted on generation of the instance
func _init():
	interest_nodes = ["P1", "P2", "P3", "P4", "P5", "P6"]
	nodes_relations = {}

func _ready():
	._ready()
	set_routes()
