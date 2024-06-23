extends Object

## Parses INI files.
## Made by Yni, licensed under CC0.

class_name IniParser
## Loads INI
func load_ini(filename: String, chunk: String, chunk_data: Array):
	var data: Array = []
	var config: ConfigFile = ConfigFile.new()
	
	var err = config.load(filename)
	if err != OK:
		printerr("No file was loaded - error.")
	
	for i in range(chunk_data.size()):
		data.append(config.get_value(chunk, str(chunk_data[i])))
	return data
## Saves INI file
func save_ini(chunk: String, keys: Array, values: Array, output: String):
	var config: ConfigFile = ConfigFile.new()
	config.load(output)
	
	for i in range(keys.size()):
		if !config.has_section_key(chunk, keys[i]):
			config.set_value(chunk, keys[i], values[i])
	
	config.save(output)
