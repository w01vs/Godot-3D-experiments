TO DO:
	build an InputManager
	Fix up interaction components with eventbus and local eventbus. 
	then convert to components where possible:
		enemy
		player
		buildcomponent from player/interact.gd
	How to do input handling? -> inputmanager with signals
	How to do UI communication? -> custom eventbus instead of signals for direct dispatch
	then continue fixing the other components:
		hitbox/hurtbox
		interaction and derived
		building -> split into placing and static
		Make equipmentcomponent instead of in player
		items
		harvestable/harvester
		inventory:
	Split inventory and hotbar input stuff, inventory is still the owner of the hotbar data




# Cool websites
https://docs.godotengine.org/en/stable
mixamo -> animations
