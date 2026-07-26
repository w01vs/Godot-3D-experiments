extends Node

signal player_set

var drag_preview: DragPreview

enum PlayerState {DEFAULT = 0, BUILD = 1}

var player: Player:
	set(value):
		player = value
		if player:
			player_set.emit()

var map: RID

var world: Node3D
