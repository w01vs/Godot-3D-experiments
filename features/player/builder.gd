class_name BuilderComponent extends Component

var structure: Entity

# data for available structures?
# StructureResource
# scene
# name
# functionality?
# category?
# group?

func set_structure(event) -> void:
	structure = event.scene.instantiate()
