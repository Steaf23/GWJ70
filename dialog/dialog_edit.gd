extends GraphEdit

@onready var node_scn = preload("res://dialog/dialog_edit_node.tscn")


func _ready() -> void:
	for c in get_children():
		c.delete_request.connect(_on_delete_request.bind(c))
		
	var create_btn = Button.new()
	create_btn.pressed.connect(_on_create_pressed)
	create_btn.text = "+"
	get_menu_hbox().add_child(create_btn)
	
	var line_edit = LineEdit.new()
	line_edit.text = "res://resources/dialog0.tres"
	line_edit.expand_to_text_length = true
	get_menu_hbox().add_child(line_edit)
	
	var save_btn = Button.new()
	save_btn.text = "Save"
	save_btn.pressed.connect(func(): _on_save_pressed(line_edit.text))
	get_menu_hbox().add_child(save_btn)
	
	var load_btn = Button.new()
	load_btn.text = "Load"
	load_btn.pressed.connect(func(): _on_load_pressed(line_edit.text))
	get_menu_hbox().add_child(load_btn)


func _on_create_pressed() -> void:
	var node = node_scn.instantiate() as DialogEditNode
	node.delete_request.connect(_on_delete_request.bind(node))
	add_child(node)


func _on_delete_request(node: DialogEditNode) -> void:
	for c in get_connection_list():
		if not node.name == c.from_node and not node.name == c.to_list:
			return
		disconnect_node(c.from_node, c.from_port, c.to_node, c.from_port)
	node.queue_free()


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if from_node == to_node:
		return
	
	for c in get_connection_list():
		if c.from_node == from_node and c.from_port == from_port:
			return
			
	connect_node(from_node, from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)

	
func _on_save_pressed(file_path: String) -> void:
	var id_counter = -1
	
	var visited_nodes = {}  # map of DialogEditNode and node_id that are seen
	var stack: Array[DialogEditNode] = [$Start]
	while not stack.is_empty():
		var node = stack.pop_front() as DialogEditNode
		if node in visited_nodes:
			continue
		
		id_counter += 1
		var node_id = id_counter
			
		for conn in get_connection_list().filter(func(other_conn): return other_conn.from_node == node.name):
			var other_node = get_node(str(conn.to_node))
			if other_node in visited_nodes:
				continue
			else:
				stack.push_back(other_node)
		
		visited_nodes[node] = node_id

	var text = DialogText.new()
	var choices = {}
	for n in visited_nodes.keys():
		var node_id = visited_nodes[n]
		if not node_id in choices.keys():
			choices[node_id] = []
			
		for conn in get_connection_list().filter(func(other_conn): return other_conn.from_node == n.name):
			choices[node_id].append(visited_nodes[get_node(str(conn.to_node))])
		
		text.lines[node_id] = n.get_text()
		
	text.choices = choices
	ResourceSaver.save(text, file_path)
	print("Saved dialog to " + file_path)
	
	
func _on_load_pressed(file_path: String) -> void:
	var text = load(file_path) as DialogText
	if not text:
		print("invalid dialog at " + file_path + " doesn't exist")
		return
	
	clear_connections()
	for c in get_children():
		c.queue_free()
	
	await get_tree().process_frame
	var placed_nodes = {}
	for line_id in text.lines.keys():
		var node = node_scn.instantiate() as DialogEditNode
		node.set_text(text.lines[line_id])
		add_child(node)
		placed_nodes[line_id] = node
		if line_id == 0:
			node.title = "START"
			node.disable_remove()
			node.name = "Start"
			node.unique_name_in_owner = true
	
	var post_idx = 0
	for node_id in text.choices.keys():
		var choices = text.choices[node_id]
		var port_idx = 0
		var from_node = placed_nodes[node_id] as DialogEditNode
		for c in choices:
			var from_port = port_idx
			var to_node = placed_nodes[c]
			connect_node(from_node.name, port_idx, to_node.name, 0)
			port_idx += 1
	print("Loaded dialog from " + file_path)
	
