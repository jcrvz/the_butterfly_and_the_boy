extends CharacterBody2D

@onready var sprite : Sprite2D = $ButterflySprite

var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	update_facing_direction()

func update_facing_direction():
	if get_parent().direction.x > 0:
		sprite.flip_h = false
#		get_node("Butterfly").
	elif direction.x < 0:
		sprite.flip_h = true
