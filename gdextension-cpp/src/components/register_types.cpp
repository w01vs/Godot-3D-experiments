#include "register_types.hpp"

#include <gdextension_interface.h>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include "event/event_base.hpp"
#include "event/event_bus_base.hpp"
#include "entity.hpp"
#include "component_area3d.hpp"
#include "event/global_event.hpp"

using namespace godot;

void initialize_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
	
	// ClassDB::register_class<TerrainChunk>();
	ClassDB::register_abstract_class<EventBase>();
	ClassDB::register_abstract_class<GlobalEventGD>();
	ClassDB::register_abstract_class<EntityEventGD>();
	ClassDB::register_class<EventBusBase::Subscriber>();
	ClassDB::register_class<EventBusBase>();
	ClassDB::register_abstract_class<Component>();
	ClassDB::register_class<Entity>();
	ClassDB::register_class<ComponentArea3D>();
}

void uninitialize_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
}

extern "C" {
// Initialization.
GDExtensionBool GDE_EXPORT components_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
	godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

	init_obj.register_initializer(initialize_module);
	init_obj.register_terminator(uninitialize_module);
	init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

	return init_obj.init();
}
}
