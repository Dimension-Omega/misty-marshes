extends Area2D

func _on_Target_body_entered(body: Node):
	if body.has_meta('player'):
		get_tree().call_group('main', 'on_target_hit')
