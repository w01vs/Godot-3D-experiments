extends Node

signal player_set

var drag_preview: DragPreview

enum PlayerState {DEFAULT = 0, BUILD = 1}

var player: Player

var map: RID

var world: Node3D

enum HealthChangeType {
	DOT,
	INSTANT,
	NONE,
}
