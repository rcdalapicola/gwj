extends CanvasLayer
class_name UIManager

@onready var score: Control = $Score
@onready var cursor: Sprite2D = $Cursor
@onready var emissor_label: Label = $Score/EmissorLabel
@onready var score_label: Label = $Score/ScoreLabel

@export var label_ref : Array[Label]
@export var label_data : Array[UILabelData]

#func change_cursor(in_game : bool):
	#print("Called")
	#
	#if in_game:
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		#cursor.visible = true
	#else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#cursor.visible = false

func _update_all_labels():
	for label_index in range(label_ref.size()):
		label_ref[label_index].text = label_data[label_index].get_text()

func update_label(label: UILabelData) -> void:
	var id = "A"
	var index := label_data.find_custom(func(d): return d.id == label.id)
	assert(index != -1, "Label called but not found: " + label.id)
	label_ref[index].text = label_data[index].get_text()
	
func update_value(id: String, value: String):
	var filtered_labels : Array[UILabelData] = label_data.filter(func(d): return d.id == id)
	if filtered_labels.size() != 1:
		push_error("One label was expected to match the id ('" + str(id) + "'). Number of matches found: " + str(filtered_labels.size()))
		return
	var label = filtered_labels[0]
	label.set_value(value)

func update_score_UI():
	score.visible = true
	var emissor = GameManager.getEmissor()
	if emissor == 1:
		emissor_label.text = "1 emissor left"
	else:
		emissor_label.text = str(emissor) + " emissors left"
	
	score_label.visible = GameManager.isScoreEnabled()
	
	score_label.text = "Score: " + str(GameManager.getScore())

func set_score_visibility(is_visible : bool) -> void:
	score_label.visible = is_visible
	
func get_score_visibility() -> bool:
	return score_label.visible

func _on_label_data_value_change(label: UILabelData):
	update_label(label)

func _initialize_labels() -> void:
	for label in label_data:
		label.value_changed.connect(_on_label_data_value_change)
	_update_all_labels()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.ui_manager = self
	_initialize_labels()
