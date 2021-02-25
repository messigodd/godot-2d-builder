extends BaseMachineGUI

var ore: BlueprintEntity
var output: Panel

onready var ore_container := $HBoxContainer/OreBar
onready var output_container := $HBoxContainer/Output
onready var tween := $Tween
onready var arrow := $HBoxContainer/GUISprite


func _ready() -> void:
	var scale: float = ProjectSettings.get_setting("game_gui/gui_scale")
	arrow.scale = Vector2(scale, scale)


func work(time: float, speed: float) -> void:
	if not is_inside_tree():
		yield(self, "ready")

	tween.interpolate_method(self, "_advance_work_time", 0.0, 1, time)
	tween.start()
	tween.playback_speed = speed


func update_speed(speed: float) -> void:
	if not is_inside_tree():
		yield(self, "ready")

	tween.playback_speed = speed


func seek(time: float) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	if tween.is_active():
		tween.seek(time)


func abort() -> void:
	tween.stop_all()
	tween.remove_all()
	arrow.material.set_shader_param("fill_amount", 0)


func _advance_work_time(amount: float) -> void:
	arrow.material.set_shader_param("fill_amount", amount)


func setup(gui: Control) -> void:
	ore_container.setup(gui)
	output_container.setup(gui)
	output = output_container.panels[0]


func grab_output(item: BlueprintEntity) -> void:
	if not output.held_item:
		output.held_item = item
	else:
		var held_item_id := Library.get_entity_name_from(output.held_item)
		var item_id := Library.get_entity_name_from(item)
		if held_item_id == item_id:
			output.held_item.stack_count += item.stack_count

		item.queue_free()
	output_container.update_labels()


func _on_OreBar_inventory_changed(_panel, held_item) -> void:
	ore = held_item
	emit_signal("gui_status_changed")


func _on_Output_inventory_changed(_panel, _held_item) -> void:
	emit_signal("gui_status_changed")


func update_labels() -> void:
	ore_container.update_labels()
	output_container.update_labels()
