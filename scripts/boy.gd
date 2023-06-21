extends CharacterBody2D

@export var speed : float = 200.0
@export var max_health : float = 100.0

@onready var sprite : Sprite2D = $Sprite
@onready var butterfly_sprite : Sprite2D = $Butterfly/ButterflySprite
@onready var damage_collision_right : CollisionPolygon2D = $DamageArea/CollisionPolygonRight
@onready var damage_collision_left : CollisionPolygon2D = $DamageArea/CollisionPolygonLeft
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collision_player : CollisionPolygon2D = $Collision
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine
@onready var health : float = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
var score : int = 0

func _ready():
	animation_tree.active = true
	damage_collision_right.disabled = false
	damage_collision_left.disabled = true
	
	Signals.kill_player.connect(kill_player)
	Signals.reward_player.connect(reward_player)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()
	
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
		damage_collision_right.disabled = false
		damage_collision_left.disabled = true
		butterfly_sprite.flip_h = false
		butterfly_sprite.offset.x = 0
	elif direction.x < 0:
		sprite.flip_h = true
		damage_collision_right.disabled = true
		damage_collision_left.disabled = false
		butterfly_sprite.flip_h = true
		butterfly_sprite.offset.x = 300
		
	
func _on_damage_area_body_entered(body):
	print("Dead!")	
	Signals.emit_signal("kill_player")

func kill_player():
	queue_free()

func reward_player(score_to_add):
	score += score_to_add
	Signals.emit_signal("update_score", score)
	print(score)
