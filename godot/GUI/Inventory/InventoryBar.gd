# Class that represents a bar of inventory slots. Transmits blueprint events up
# to the preview controller.
extends HBoxContainer


var held_item: BlueprintEntity setget _set_held_item, _get_held_item
var drag_preview: Control
var panels := []


func _ready() -> void:
	for container in get_children():
		if container is InventoryPanel:
			panels.push_back(container)
		else:
			panels.push_back(container.get_child(1))


func setup(_drag_preview: Control) -> void:
	drag_preview = _drag_preview


func destroy_held_item() -> void:
	drag_preview.destroy_blueprint()


func _set_held_item(value: BlueprintEntity) -> void:
	drag_preview.blueprint = value


func _get_held_item() -> BlueprintEntity:
	if drag_preview:
		return drag_preview.blueprint
	else:
		return null
