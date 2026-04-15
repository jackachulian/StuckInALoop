extends MarginContainer

static var music_volume: float = 70
static var sfx_volume: float = 70

@onready var music_volume_slider: HSlider = $PanelContainer/VBoxContainer/VBoxContainer/MusicVolume/HBoxContainer/HSlider
@onready var music_volume_percent: Label = $PanelContainer/VBoxContainer/VBoxContainer/MusicVolume/HBoxContainer/Percent

@onready var sfx_volume_slider: HSlider = $PanelContainer/VBoxContainer/VBoxContainer/SFXVolume/HBoxContainer/HSlider
@onready var sfx_volume_percent: Label = $PanelContainer/VBoxContainer/VBoxContainer/SFXVolume/HBoxContainer/Percent

func _ready() -> void:
	music_volume_slider.value_changed.connect(_on_music_volume_slider_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_slider_changed)
	
	music_volume_slider.value = music_volume
	sfx_volume_slider.value = sfx_volume
	
func _on_music_volume_slider_changed(value: float):
	music_volume = value
	music_volume_percent.text = str(int(music_volume))+"%"
	
func _on_sfx_volume_slider_changed(value: float):
	sfx_volume = value
	sfx_volume_percent.text = str(int(sfx_volume))+"%"
