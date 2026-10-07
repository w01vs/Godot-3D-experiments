#include "register_types.hpp"

#include <gdextension_interface.h>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include "components/component-3d/collision_data.hpp"
#include "components/component-3d/component_area3d.hpp"
#include "components/component-3d/component_characterbody3d.hpp"
#include "components/component-3d/component_meshinstance3d.hpp"
#include "components/component-3d/component_raycast3d.hpp"
#include "components/component-3d/component_staticbody3d.hpp"
#include "components/component-3d/events/collision_entered_event.hpp"
#include "components/component-3d/events/collision_exit_event.hpp"
#include "components/component-3d/events/collision_oneshot_event.hpp"
#include "components/component-3d/events/raycast_event.hpp"
#include "components/component.hpp"
#include "components/entity.hpp"
#include "components/event/event_base.hpp"
#include "components/event/event_bus.hpp"
#include "components/event/event_bus_base.hpp"
#include "components/event/global_event.hpp"
#include "components/event/world_loaded_event.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include "worldgen/terrainchunk.hpp"

using namespace godot;

void initialize_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	
	ClassDB::register_class<EventBaseGD>(true);
	ClassDB::register_class<GlobalEventGD>(true);
	ClassDB::register_class<EntityEventGD>(true);
	ClassDB::register_class<WorldLoadedEvent>(true);
	
	ClassDB::register_class<EventBusBase::Subscriber>();
	ClassDB::register_class<EventBusBase>();
	
	ClassDB::register_class<EventBus>();
	ClassDB::_register_engine_singleton(StringName("EventBus"), EventBus::get_singleton());

	ClassDB::register_class<Entity>();
	ClassDB::register_class<Component>(true);

	ClassDB::register_class<CollisionDataGD>(true);

	ClassDB::register_class<CollisionExitEntityEvent>();
	ClassDB::register_class<CollisionEnteredEntityEvent>();
	ClassDB::register_class<CollisionOneshotEntityEvent>();
	ClassDB::register_class<RayCastEntityEvent>();

	ClassDB::register_class<ComponentArea3D>();
	ClassDB::register_class<ComponentStaticBody3D>();
	ClassDB::register_class<ComponentCharacterBody3D>();
	ClassDB::register_class<ComponentMeshInstance3D>();
	ClassDB::register_class<ComponentRayCast3D>();

	ClassDB::register_class<TerrainChunk>();
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
