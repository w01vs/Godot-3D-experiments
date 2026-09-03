class_name Utils

static func is_of_type(child: Script, parent: Script, early_stop: Script = null) -> bool:
	var current_script: Script = child
	while current_script and current_script != early_stop and current_script != parent:
		current_script = current_script.get_base_script()
		if current_script == parent:
			return true
	return false
