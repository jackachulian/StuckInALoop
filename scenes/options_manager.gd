class_name OptionsManager

static var music_volume: float
static var sfx_volume: float

static var beat_offset_milliseconds: int

static var input_delay_milliseconds: int

static var config: ConfigFile

static func save_config():
	config.set_value("options", "music_volume", music_volume)
	config.set_value("options", "sfx_volume", sfx_volume)
	config.set_value("options", "beat_offset_milliseconds", beat_offset_milliseconds)
	config.set_value("options", "input_delay_milliseconds", input_delay_milliseconds)
	config.save("user://config.ini")

static func load_config():
	config = ConfigFile.new()
	config.load("user://config.ini")
	music_volume = config.get_value("options", "music_volume", 70)
	sfx_volume = config.get_value("options", "sfx_volume", 70)
	beat_offset_milliseconds = config.get_value("options", "beat_offset_milliseconds", 0)
	input_delay_milliseconds = config.get_value("options", "input_delay_milliseconds", 0)
