extends Resource
class_name RunState

@export var command_zone: CommandZone
@export var inventory: Inventory

# TODO: this should be default set to the flagship at some point
@export_storage var selected_cz_coords: Vector2i
