class_name InventoryBindings extends RefCounted

var grab_drop: Callable
var inventory_changed: Signal

func _init(grab_drop_: Callable, inventory_changed_: Signal) -> void:
	grab_drop = grab_drop_
	inventory_changed = inventory_changed_
