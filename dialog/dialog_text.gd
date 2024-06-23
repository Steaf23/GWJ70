class_name DialogText
extends Resource

@export var lines = {}
@export var choices = {0: []}
@export var events = {}

@export var id_counter = 0


func add_line(text: String, parent: int = 0, back_tracks: Array[int] = [], _events: Array[StringName] = []) -> int:
	id_counter += 1
	lines[id_counter] = text
	
	assert(choices[parent].size() < 3, "text " + str(parent) + " cannot have more than 3 children!")
	choices[parent].append(id_counter)
	
	choices[id_counter] = []
	choices[id_counter].append_array(back_tracks)
		
	return id_counter
	
	
var printed = []
func print_text() -> void:
	printed.clear()
	_print_text_recurse()
	
	
func _print_text_recurse(id = 0, tab_level = -1) -> void:
	if id in printed:
		return
	
	printed.append(id)
	if id == 0:
		print("START")
	else:
		var s = ""
		for t in tab_level:
			s += "\t"
		print(s + str(id) + ": " + lines[id - 1])
	
	if not id in choices.keys():
		return
			
	for choice_id in choices[id]:
		_print_text_recurse(choice_id, tab_level + 1)


func get_line(id: int) -> String:
	return lines[id]


func add_event(line_id: int, event: String) -> void:
	events[line_id] = event
