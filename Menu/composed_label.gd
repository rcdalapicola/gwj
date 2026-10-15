extends Resource
class_name UILabelData

signal value_changed(label: UILabelData)

@export var id : String
@export var fixed_text : String
@export var variable_text : String

func get_text() -> String:
	return fixed_text + variable_text

func set_value(value: String) -> void:
	variable_text = value
	value_changed.emit(self)
