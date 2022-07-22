extends Node


func add_commas(number: int) -> String:
	var ret = ""
	var string_number := str(number)

	for i in string_number.length():
		if i % 3 == string_number.length() % 3 and i > 0:
			ret += ","
		ret += string_number[i]
	return ret
