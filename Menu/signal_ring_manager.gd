extends Node

static var instance: SignalRingManager

func _enter_tree() -> void:
	instance = self

func register_ring(position: Vector2, max_progress: float = 0.25, color: Color = Color(0.2, 1.0, 0.3, 1.0), ring_width: float = 0.01) -> int:
	return -1

func update_ring(idx: int, progress: float) -> void:
	pass
