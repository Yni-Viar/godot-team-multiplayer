extends Object
## Store there global settings
## Made by Yni, licensed under CC0.
class_name Globals

enum Stages {release, testing, dev}
enum ItemType {item, map_object, npc}
## For compatibility checking (not implemented here, mostly a SCP: SO remnant)
static var data_compatibility: String = "0.1.0"
## Development stage. The main menu image is dependent on this value...
static var current_stage: Stages = Stages.dev
static var full_version_name: String = "TGPY-project-base"
