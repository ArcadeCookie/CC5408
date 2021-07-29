extends "res://Scripts/Entities/Enemy2.gd"
# Specific instance of an Enemy object
# Hierarchy: This -> Enemy -> Node -> ...


# Exectuted on generation of the instance
func _init():
	interest_nodes = ["P5", "B1", "B2"]
	nodes_relations = {}

func _ready():
	._ready()
	set_routes()

func init():
	var node = interest_nodes[0]
	var node_pos = self.to_global(node.get_translation())
	node_pos.y = 1.5 
	set_translation(node_pos)
	set_physics_process(true)
