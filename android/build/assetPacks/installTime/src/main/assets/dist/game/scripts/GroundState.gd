extends State

class_name GroundState

@export var jump_velocity : float = -250.0
@export var air_state : State
@export var jump_animation : String = "jump"
@export var duck_state : State
@export var duck_node :  String = "duck"


func state_process(delta):
	if(!character.is_on_floor()):
		next_state = air_state

func state_input(event : InputEvent):
	if(event.is_action_pressed("ui_select")):
		jump()
#	if(event.is_action_pressed("duck")):
#		duck()

func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)

func duck():
	next_state = duck_state
	playback.travel(duck_node)
