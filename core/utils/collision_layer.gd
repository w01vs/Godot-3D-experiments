class_name CollisionLayer

const NONE: int = 0
const TERRAIN: int = 1
const INTERACTABLE: int = 2
const HURTBOX: int = 3
const HITBOX: int = 4
const STRUCTURE: int = 5
const LIVING: int = 6
const HARVESTABLE: int = 7

static func combine(...layers: Array) -> int:
	var mask: int = 0
	for i: int in layers:
		mask = mask | (1 << (i - 1))
	return mask
