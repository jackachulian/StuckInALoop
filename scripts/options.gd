extends MarginContainer

@onready var music_volume_slider: HSlider = $PanelContainer/VBoxContainer/VBoxContainer/MusicVolume/HBoxContainer/HSlider
@onready var music_volume_percent: Label = $PanelContainer/VBoxContainer/VBoxContainer/MusicVolume/HBoxContainer/Percent

@onready var sfx_volume_slider: HSlider = $PanelContainer/VBoxContainer/VBoxContainer/SFXVolume/HBoxContainer/HSlider
@onready var sfx_volume_percent: Label = $PanelContainer/VBoxContainer/VBoxContainer/SFXVolume/HBoxContainer/Percent

@onready var offset_ms_label: Label = $PanelContainer/VBoxContainer/VBoxContainer/TimingOffset/HBoxContainer/Percent

func _ready() -> void:
	music_volume_slider.value_changed.connect(_on_music_volume_slider_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_slider_changed)
	
	music_volume_slider.value = OptionsManager.music_volume
	sfx_volume_slider.value = OptionsManager.sfx_volume
	_on_offset_changed() # for setting to initial value
	
func _on_music_volume_slider_changed(value: float):
	OptionsManager.music_volume = value
	music_volume_percent.text = str(int(OptionsManager.music_volume))+"%"
	
func _on_sfx_volume_slider_changed(value: float):
	OptionsManager.sfx_volume = value
	sfx_volume_percent.text = str(int(OptionsManager.sfx_volume))+"%"

func _on_offset_increase_pressed():
	OptionsManager.beat_offset_milliseconds += 5
	_on_offset_changed()
	
func _on_offset_decrease_pressed():
	if (OptionsManager.beat_offset_milliseconds <= 0): return;
	OptionsManager.beat_offset_milliseconds -= 5
	_on_offset_changed()
	
func _on_offset_changed():
	offset_ms_label.text = str(OptionsManager.beat_offset_milliseconds)+"ms"
