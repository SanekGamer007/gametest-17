extends Node

func _ready():
	var real_key_hex = "eab84ea6bf5661feb2ab2317b6baf32eb52bbc3745155e71bf635631c37bbb12"

	# 1. Сразу превращаем в сырые 32 байта
	var raw_bytes = real_key_hex.hex_decode()

	var output = "{"
	var xor_byte = 0x6C # Запомни это число!

	for b in raw_bytes:
		var scrambled = b ^ xor_byte
		output += "0x%02X, " % scrambled

	print(output + "};")
