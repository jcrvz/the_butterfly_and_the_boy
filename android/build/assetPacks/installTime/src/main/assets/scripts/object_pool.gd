extends Node

class_name ObjectPool

@export var g_copies_of_each : int = 5
@export var g_y_tracks : Array = [150, 300, 500]
@export var g_object_velocity : int = 5
@export var g_starting_x : int = 1500
@export var g_path : String = ""
@export var g_min_spawn_wait_ms : int = 1000
@export var g_max_spawn_wait_ms : int = 2000

var g_max_available_objects : int = 0
var g_object_pool : Array = []
var g_object_pool_available : Array = []

var g_last_spawn_time_ms : int = 0
var g_rand_spawn_wait_ms : int = 0

const LEFT_BOUND : int = -50

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all the paths in g_path
	var paths : Array = _get_full_paths(g_path)
#	print("paths = ", paths)
	# For each path
	for path in paths:
		var resource = load(path)
		for _i in g_copies_of_each:
			var object : Node2D = resource.instantiate()
			object.global_position = _get_random_global_position(object)
			object.z_index = 5
			
			g_object_pool.append(object)
			g_object_pool_available.append(object)
			
			add_child(object)
#			get_parent().call_deferred('add_child_below_node', self, object)
			
	# 	load the resource at that path
	
	# 	make g_copies_of_each copies of it
	
	# 	put the resource into our pool of objects

func _get_full_paths(path: String) -> Array:
	if path.ends_with(".tscn"):
		return [path]
	
	var files = _list_files_in_directory(path)
	var paths = []
	for file in files:
		paths.append(path + file)
	return paths

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_diff = Time.get_ticks_msec() - g_last_spawn_time_ms
	if time_diff > g_rand_spawn_wait_ms:
		var available_object = _find_and_remove_available_object()
		if available_object:
			available_object.global_position = _get_random_global_position(available_object)
			available_object.start(g_object_velocity)
			g_last_spawn_time_ms = Time.get_ticks_msec()
			g_rand_spawn_wait_ms = randf_range(g_min_spawn_wait_ms, g_max_spawn_wait_ms)
		_add_to_available_objects()
		
func _add_to_available_objects() -> void:
	for object in g_object_pool:
		if object.is_inside_tree() and object.global_position.x < LEFT_BOUND:
			object.global_position = _get_random_global_position(object)
			object.reset()
			g_object_pool_available.append(object)
			
			
func _find_and_remove_available_object() -> Node2D:
	if g_object_pool_available.size() == 0:
		return null
	
	var available_index : int = randi() % g_object_pool_available.size()
	var available_object : Node2D = g_object_pool_available[available_index]
	g_object_pool_available.remove_at(available_index)
	return available_object
	
func _get_random_global_position(object: Node2D) -> Vector2:
	var texture_height : float = object.get_height()
	var starting_y : int  #
		
	if object.on_ground:
		starting_y = g_y_tracks[-1]
	else:
		starting_y = g_y_tracks[randi_range(0, 2)]
#	print(starting_y)
	
	return Vector2(g_starting_x, starting_y)
	
func _list_files_in_directory(path: String) -> Array:
	var files : Array = []
	var dir := DirAccess.open(path)
	
	dir.list_dir_begin()
	
	while true:
		var file : String = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
		
	return files
