#include "component.hpp"
#include "godot_cpp/classes/engine.hpp"
#include "godot_cpp/classes/global_constants.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/core/object.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include "utils/utils.hpp"

const char *Component::GROUP = "COMPONENT";

void Component::_bind_methods() {
	GDVIRTUAL_BIND(_on_entity_load);
	GDVIRTUAL_BIND(_init_component);
	GDVIRTUAL_BIND(_on_enable);
	GDVIRTUAL_BIND(_on_disable);
	ClassDB::bind_method(D_METHOD("subscribe", "event_type", "callback", "priority"), &Component::subscribe, DEFVAL(EventBusBase::Priority::BASE));
	ClassDB::bind_method(D_METHOD("emit", "event"), &Component::emit);

	ClassDB::bind_method(D_METHOD("get_entity"), &Component::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity", "p_entity"), &Component::set_entity);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "entity", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_entity", "get_entity");

	ClassDB::bind_method(D_METHOD("enable"), &Component::enable);
	ClassDB::bind_method(D_METHOD("disable"), &Component::disable);

	ClassDB::bind_method(D_METHOD("is_active"), &Component::is_active);
}

void Component::_ready() {
	if (Engine::get_singleton()->is_editor_hint()) {
		return;
	}
	GDASSERT(entity, "No entity set for component: ", UtilityFunctions::str(this));
	GDASSERT(entity->is_ancestor_of(this), "Component ", UtilityFunctions::str(this), " is incorrectly nested? See its entity: ", UtilityFunctions::str(entity));
	entity->register_component(this);
	entity->connect("ready", Callable{ this, "_on_entity_load" });
	add_to_group(Component::GROUP);
	_init_component();
}

void Component::_on_entity_load() {
	if (GDVIRTUAL_IS_OVERRIDDEN(_on_entity_load)) {
		GDVIRTUAL_CALL(_on_entity_load);
	}
}

void Component::_init_component() {
	if (GDVIRTUAL_IS_OVERRIDDEN(_init_component)) {
		GDVIRTUAL_CALL(_init_component);
	}
}

void Component::_notification(int what) {
	switch (what) {
		case NOTIFICATION_PREDELETE:
			if (!Engine::get_singleton()->is_editor_hint() && entity) {
				entity->remove_component(this);
			}
		default:
			return;
	}
}

void Component::enable() {
	active = true;
	_on_enable();
}

void Component::_on_enable() {
	if (GDVIRTUAL_IS_OVERRIDDEN(_on_enable)) {
		GDVIRTUAL_CALL(_on_enable);
	}
}

void Component::disable() {
	active = false;
	_on_disable();
}

void Component::_on_disable() {
	if (GDVIRTUAL_IS_OVERRIDDEN(_on_disable)) {
		GDVIRTUAL_CALL(_on_disable);
	}
}

void Component::subscribe(const Variant &event_type, Callable callback, EventBusBase::Priority priority) {
	Ref<Script> event = Object::cast_to<Script>(event_type);
	bool inherits = Utils::inherits(EntityEventGD::get_class_static(), event_type);
	if (inherits) {
		entity->subscribe(this, event_type, callback, priority);
	} else {
		entity->subscribe_global(this, event_type, callback, priority);
	}
}

void Component::emit(Ref<EventBaseGD> event) {
	if (Object::cast_to<EntityEventGD>(event.ptr())) {
		entity->emit_local(event);
	} else {
		entity->emit_global(event);
	}
}