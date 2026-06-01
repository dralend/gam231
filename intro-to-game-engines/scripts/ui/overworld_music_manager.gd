extends Node

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

@export var playlist: Array[AudioStream] = []

@export var shuffle_playlist: bool = false
@export var start_automatically: bool = true
@export var volume_db: float = -8.0

var current_track_index: int = 0
var played_tracks: Array[int] = []


func _ready() -> void:
	music_player.volume_db = volume_db
	music_player.finished.connect(_on_track_finished)

	if start_automatically and playlist.size() > 0:
		play_track(0)


func play_track(index: int) -> void:
	if playlist.is_empty():
		return

	current_track_index = index
	music_player.stream = playlist[current_track_index]
	music_player.play()


func _on_track_finished() -> void:
	if shuffle_playlist:
		play_random_track()
	else:
		play_next_track()


func play_next_track() -> void:
	current_track_index += 1

	if current_track_index >= playlist.size():
		current_track_index = 0

	play_track(current_track_index)


func play_random_track() -> void:
	if playlist.size() <= 1:
		play_track(0)
		return

	var next_index := current_track_index

	while next_index == current_track_index:
		next_index = randi_range(0, playlist.size() - 1)

	play_track(next_index)
