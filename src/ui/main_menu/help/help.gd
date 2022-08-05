extends Control


var selected_page: Control

onready var pages_amount := get_node("%Pages").get_child_count()


func _ready() -> void:
	_select_page(0)


func _on_GoLeft_button_up() -> void:
	var idx = get_node("%Pages").get_children().find(selected_page)
	_select_page(idx-1)


func _on_GoRight_button_up() -> void:
	var idx = get_node("%Pages").get_children().find(selected_page)
	_select_page(idx+1)


func _select_page(page_idx: int) -> void:
	#print(page_idx)
	if is_instance_valid(selected_page):
		selected_page.hide()
	selected_page = get_node("%Pages").get_children()[page_idx]
	selected_page.show()


	get_node("%GoLeft").disabled = page_idx == 0
	get_node("%GoRight").disabled = page_idx+1 == pages_amount



func _on_Button_down() -> void:
	GlobalSoundManager.play("res://assets/sounds/kenney_interfacesounds/Audio/click_004.ogg")

