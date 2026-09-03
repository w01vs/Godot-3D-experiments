### TO DO:
    Player: 
        -> Fix player xz velocity cancelling too slow when opening inventory etc.
            * this is annoying cus xz velocity can be rotated and the total vector needs to be lowered.
            * have to do some math to get the proportional xz components of the xz velocity to cancel it
	Structures:
        Crucible functionality
        -> crafting menu ui
        -> recipe resources
        -> crafting component
	Items:
        -> merging dropped items if they overlap on the ground
    Components:
        -> add interaction component hover stuff (billboard label)

maybe ill eventually get around to making a new AI stuffs with a plugin
then ill also make components for whatever an enemy needs. dont feel like doing it; also probably not needed?

## Comment keywords
TODO
REMIND

to find comments:
rg -g "*.gd" -g "!addons/*" -g "!gdextension/*" -g "features/procedural/*" '#'

to find todos:
rg -g "*.gd" "TODO"

### Cool websites
https://docs.godotengine.org/en/stable
mixamo -> animations
