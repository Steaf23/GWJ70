extends Control


func _ready() -> void:
	$HBoxContainer/InputKey.set_key(&"pause")
	$HBoxContainer/InputKey2.set_manually("ESC")
	SoundManager.play_music(Sounds.MUSIC_DIALOG)


func _on_dialog_finished() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_start_pressed() -> void:
	$CanvasLayer/Dialog.load_text_from_file("res://resources/title.tres")
	$ButtonClick.play()
