extends Node

signal music_ended(path: String)

@export var _pool_size: int = 10

@onready var _music_player = $MusicPlayer
@onready var _sfx_pool = $SFXPool

var _player_counter = 0


func _enter_tree():
	AudioServer.set_bus_layout(load("res://SoundManager/bus_layout.tres"))
	randomize()


func update_bus(bus_name, value) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), true if value == 0 else false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value / 100))


func play_music(path: String, volume_percent: float = 1.0) -> void:
	if _music_player.playing:
		if path == _music_player.stream.resource_path:
			return
		else:
			_music_player.stop()
		
	if !ResourceLoader.exists(path):
		print("Cannot find " + path + "!")
		
	_music_player.stream = load(path)
	_music_player.volume_db = linear_to_db(volume_percent)
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()
	
	
func muffle_music(muffle: bool) -> void:
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, muffle)

# Play new sounds, while removing the oldest currently playing if the pool is full.
# this results in the most satisfying outcome.
func play_sfx(path: String, volume_percent = 1.0, pitch_scale = 1.0) -> void:
	if !ResourceLoader.exists(path):
		print("Cannot find " + path + "!")
	
	if _sfx_pool.get_children().size() >= _pool_size:
		_stop_player(_get_oldest_player())
	
	var player = AudioStreamPlayer.new()
	
	player.bus = &"SFX"
	player.set_meta("path", path)
	player.set_meta("id", _player_counter)
	player.stream = load(path)
	player.finished.connect(_on_player_finished.bind(player))
	_player_counter += 1
	_sfx_pool.add_child(player)
	player.play()
	player.volume_db = linear_to_db(volume_percent)
	player.pitch_scale = pitch_scale


func play_sfx_2d(path, position: Vector2, volume_percent = 1.0, pitch_scale = 1.0) -> void:
	if !ResourceLoader.exists(path):
		print("Cannot find " + path + "!")
	
	if _sfx_pool.get_children().size() >= _pool_size:
		_stop_player(_get_oldest_player())
	
	var player = AudioStreamPlayer2D.new()
	
	player.bus = &"SFX"
	player.set_meta("path", path)
	player.set_meta("id", _player_counter)
	player.stream = load(path)
	player.finished.connect(_on_player_finished.bind(player))
	_player_counter += 1
	_sfx_pool.add_child(player)
	player.play()
	player.volume_db = linear_to_db(volume_percent)
	player.pitch_scale = pitch_scale
	player.global_position = position
	player.max_distance = 1000
	

func play_random_sfx(sounds: Array, volume_percent = 1.0, pitch_scale = 1.0) -> void:
	var idx = randi() % sounds.size()
	play_sfx(sounds[idx], volume_percent, pitch_scale)
	
	
func play_random_sfx_2d(sounds: Array, position: Vector2, volume_percent = 1.0, pitch_scale = 1.0) -> void:
	var idx = randi() % sounds.size()
	play_sfx_2d(sounds[idx], position, volume_percent, pitch_scale)
	

func stop_sfx(path: String) -> void:
	for player in _sfx_pool.get_children():
		if player.get_meta("path") == path:
			player.stop()
			player.queue_free()
			return
			
			
func _stop_player(player: Node) -> void:
	player.stop()
	player.queue_free()


func _get_oldest_player() -> Node:
	if _sfx_pool.get_child_count() == 0:
		return null
		
	var oldest_record = 0
	var oldest_player = _sfx_pool.get_children()[0]
	for player in _sfx_pool.get_children():
		if player.get_meta("id") < oldest_record:
			oldest_player = player
			oldest_record = player.get_meta("id")
	
	return oldest_player


func _on_player_finished(player: Node) -> void:
	player.queue_free()


func _on_music_player_finished() -> void:
	music_ended.emit(_music_player.stream.resource_path)


func _ready() -> void:
	$BG.play()
