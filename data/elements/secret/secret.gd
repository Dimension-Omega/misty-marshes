extends Area2D


func _on_Secret_body_entered(body):
	if body.has_meta('player'):
		get_tree().call_group('main', 'on_secret_found')
		queue_free()
