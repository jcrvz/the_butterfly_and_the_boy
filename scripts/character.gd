extends StaticBody2D

@export var g_velocity : float = 0
@export var default_animation : String = "moving"
@export var on_ground : bool = false

func _process(delta):
	position.x += g_velocity

func get_height() -> float:
	return $Sprite2D.texture.get_size().y * scale.y * $Sprite2D.scale.y
	
func reset() -> void:
	g_velocity = 0
	Signals.emit_signal("reward_player", 1)
	
func start(velocity: float) -> void:
	g_velocity = -velocity
	$AnimationPlayer.play(default_animation)

