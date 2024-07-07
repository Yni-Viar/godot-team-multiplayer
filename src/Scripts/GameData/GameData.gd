extends Resource
## Game DB.
## Made by Yni, licensed under MIT license.
class_name GameData
## Available player classes
@export var classes: Array[BaseClass]
## Available inventory items
@export var items: Array[Item]
## Available pickables and other items (unused)
@export var map_objects: Array[PackedScene]
## Available NPCs (unused)
@export var npcs: Array[PackedScene]


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_classes: Array[BaseClass] = [], p_items: Array[Item] = [], p_map_objects: Array[PackedScene] = [], p_npcs: Array[PackedScene] = []):
	classes = p_classes
	items = p_items
	map_objects = p_map_objects
	npcs = p_npcs
