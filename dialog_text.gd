class_name DialogText
extends Resource

@export var lines = []
@export var choices = {0: []}
@export var events = {}

@export var id_counter = 0


func add_line(text: String, parent: int = 0, back_tracks: Array[int] = [], events: Array[StringName] = []) -> int:
	id_counter += 1
	lines.append(text)
	
	assert(choices[parent].size() < 3, "text " + str(parent) + " cannot have more than 3 children!")
	choices[parent].append(id_counter)
	
	choices[id_counter] = []
	choices[id_counter].append_array(back_tracks)
		
	return id_counter


func _init() -> void:
	#var first = add_line("start the text or smth")
	#var second = add_line("continue start", first)
	#var third = add_line("continue second", second)
	#var fourth = add_line("add to second", second, [second])
	#var fifth = add_line("continue third", third)
	#var sixth = add_line("on the bas3e")
	#var seventh = add_line("on the base", first)
	pass
	
	
var printed = []
func print_text() -> void:
	printed.clear()
	print_text_recurse()
	
	
func print_text_recurse(id = 0, tab_level = -1) -> void:
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
		print_text_recurse(choice_id, tab_level + 1)
