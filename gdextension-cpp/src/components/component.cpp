#include "component.hpp"
#include "event/event_bus.hpp"
#include "godot_cpp/classes/engine.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "utils/utils.hpp"

void Component::_bind_methods() {
	GDVIRTUAL_BIND(_on_entity_load);
	GDVIRTUAL_BIND(_init_component);
	ClassDB::bind_method(D_METHOD("_on_entity_load"), &Component::_on_entity_load);
	ClassDB::bind_method(D_METHOD("_init_component"), &Component::_init_component);
	ClassDB::bind_method(D_METHOD("subscribe", "event_type", "callback", "priority"), &Component::subscribe, DEFVAL(EventBusBase::Priority::BASE));
	ClassDB::bind_method(D_METHOD("emit", "event"), &Component::emit);

	ClassDB::bind_method(D_METHOD("get_entity"), &Component::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity", "entity"), &Component::set_entity);
}

void Component::_ready() {
	assert(entity);
	assert(entity->is_ancestor_of(this));
	entity->register_component(this);
	entity->connect("ready", Callable{ this, "_on_entity_load" });
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

void Component::subscribe(Ref<Script> event_type, Callable callback, EventBusBase::Priority priority) {
	if (Utils::is_of_type(event_type, Entity::ENTITY_EVENT_SCRIPT(), EventBus::BASE_EVENT_SCRIPT)) {
		entity->subscribe(this, event_type, callback, priority);
	} else {
		entity->subscribe_global(this, event_type, callback, priority);
	}
}

void Component::emit(Ref<EventBase> event) {
	if (Object::cast_to<EntityEventGD>(event.ptr())) {
		entity->emit_local(event);
	} else {
		entity->emit_global(event);
	}
}