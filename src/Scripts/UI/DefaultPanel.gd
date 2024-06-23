extends Panel
## Main menu components.
## Made by Yni, licensed under CC0.
class_name DefaultPanel


func _on_host_pressed():
	get_tree().root.get_node("Main").host()
	get_parent().get_node("AudioStreamPlayer").playing = false


func _on_ip_address_text_changed(new_text):
	NetworkManager.ip_address = new_text
	if NetworkManager.ip_address.is_empty():
		NetworkManager.ip_address = "127.0.0.1"


func _on_port_text_changed(new_text):
	if new_text.is_empty():
		NetworkManager.port = 7877
	else:
		NetworkManager.port = int(new_text)


func _on_max_clients_text_changed(new_text):
	if new_text.is_empty():
		NetworkManager.max_players = 20
	else:
		NetworkManager.max_players = int(new_text)


func _on_connect_pressed():
	get_tree().root.get_node("Main").join()
	get_parent().get_node("AudioStreamPlayer").playing = false
