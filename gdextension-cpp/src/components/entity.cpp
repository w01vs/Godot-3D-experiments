#include "entity.hpp"
#include "component.hpp"
#include "components/event/event_bus_base.hpp"
#include "event/event_bus.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include "utils/utils.hpp"

void Entity::_bind_methods() {
	ClassDB::bind_method(D_METHOD("has_component", "type"), &Entity::has_component);
	ClassDB::bind_method(D_METHOD("register_component", "component"), &Entity::register_component);
	ClassDB::bind_method(D_METHOD("get_component", "type"), &Entity::get_component);
	ClassDB::bind_method(D_METHOD("remove_component", "component"), &Entity::remove_component);
	
}

Entity::Entity() {
	local_event_bus = memnew(EventBusBase);
}

void Entity::_ready() {
	local_event_bus->enable();
	local_event_bus->release_events();
}

void Entity::register_component(const Component *component) {
	for (Ref<Script> script : find_bases(component->get_script())) {
		component_map.set(script, component);
	}
}

Component *Entity::get_component(const Ref<Script> &script) {
	return Object::cast_to<Component>(component_map.get(script, nullptr));
}

bool Entity::has_component(const Ref<Script> &script) {
	return component_map.has(script);
}

void Entity::remove_component(const Component *component) {
	for (Variant script : find_bases(component->get_script())) {
		if (get_component(script) == component) {
			component_map.erase(component->get_script());
		}
	}

	for (Ref<Script> event : global_subscriptions.keys()) {
		TypedArray<Callable> callbacks = global_subscriptions.get(event, Variant());
		for (int i = callbacks.size(); i >= 0; i--) {
			Callable cb = callbacks.get(i);
			if (cb.is_valid() && Object::cast_to<Component>(cb.get_object()) == component) {
				callbacks[i] = callbacks[callbacks.size() - 1];
				callbacks.pop_back();
				if (callbacks.size() == 0) {
					global_subscriptions.erase(event);
				}
			}
		}
	}
}

Array Entity::find_bases(const Variant &p_script, bool removing) {
	Ref<Script> current = Object::cast_to<Script>(p_script);
	if(current.ptr()){
		TypedArray<Script> scripts = TypedArray<Script>();
		while (current.is_valid() && current->get_instance_base_type() == Component::get_class_static() && !current->is_abstract()) {
			if (component_map.has(current) && !removing) {
				UtilityFunctions::push_error("A component of this type %s has already been registered", current->get_global_name());
				return TypedArray<Script>{};
			}
			scripts.append(current);
			current = current->get_base_script();
		}
		return scripts;
	}
	String name = Object::cast_to<Object>(p_script)->get_class();

	TypedArray<StringName> types = TypedArray<StringName>();
	while(!ClassDB::is_parent_class(name, Component::get_class_static())) {
		types.append(name);
		name = ClassDB::get_parent_class(name);
	}

	return types;
}

void Entity::subscribe(Component *component, const Variant &event_type, const Callable &callback, EventBusBase::Priority priority) {
	GDASSERT(EventBaseGD::validate_event_script(event_type), "Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
	if (!EventBaseGD::validate_event_script(event_type)) {
		UtilityFunctions::push_error("Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
		return;
	}
	bool inherits = Utils::inherits(EntityEventGD::get_class_static(), event_type);
	GDASSERT(inherits, "EventBus events need to derive from EntityEventGD");
	if(!inherits) {
		UtilityFunctions::push_error("EventBus events need to derive from EntityEventGD");
		return;
	}
	local_event_bus->subscribe(event_type, callback, Callable{ Object::cast_to<Object>(component), "is_active" }, priority);
}

void Entity::unsubscribe(const Variant &event_type, const Callable &callback) {
	GDASSERT(EventBaseGD::validate_event_script(event_type), "Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
	if (!EventBaseGD::validate_event_script(event_type)) {
		UtilityFunctions::push_error("Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
		return;
	}
	bool inherits = Utils::inherits(EntityEventGD::get_class_static(), event_type);
	GDASSERT(inherits, "EventBus events need to derive from EntityEventGD");
	if(!inherits) {
		UtilityFunctions::push_error("EventBus events need to derive from EntityEventGD");
		return;
	}
	local_event_bus->unsubscribe(event_type, callback);
}

void Entity::emit_local(const Ref<EntityEventGD> &event) {
	if (!active) {
		return;
	}
	local_event_bus->emit(event);
}

void Entity::subscribe_global(const Component *component, const Variant &event_type, const Callable &callback, EventBusBase::Priority priorit) {
	if (!global_subscriptions.has(event_type)) {
		global_subscriptions[event_type] = TypedArray<Callable>{};
	}
	TypedArray<Callable> arr = global_subscriptions[event_type];
	if (!arr.has(callback)) {
		arr.append(callback);
		EventBus::get_singleton()->subscribe(event_type, Callable{this, "_callback_internal"});
	}
}

void Entity::unsubscribe_global(const Variant &event_type, const Callable &callback) {
	EventBus::get_singleton()->unsubscribe(event_type, callback);
	TypedArray<Callable> callbacks = global_subscriptions[event_type];
	for (int i = 0; i < callbacks.size(); i++) {
		Callable cb = callbacks.get(i);
		if (!cb.is_valid()) {
			continue;
		}
		if (cb == callback) {
			callbacks[i] = callbacks[callbacks.size() - 1];
			callbacks.pop_back();
			return;
		}
	}
}

void Entity::emit_global(const Ref<GlobalEventGD> &event) {
	if (!active) {
		return;
	}
	event->set_source(this);
	EventBus::get_singleton()->emit(event);
}

void Entity::callback_internal(const Ref<EventBaseGD> &event) {
	Ref<Script> event_type = event->get_script();
	if (global_subscriptions.has(event_type)) {
		TypedArray<Callable> callbacks = global_subscriptions[event_type];
		for (int i = callbacks.size(); i >= 0; i--) {
			Callable cb = callbacks.get(i);
			if (cb.is_valid()) {
				cb.call(event);
			} else {
				callbacks[i] = callbacks[callbacks.size() - 1];
				callbacks.pop_back();
			}
		}
	}
}

void Entity::process_event(const Ref<EntityEventGD> &event) {
	emit_local(event);
}

void Entity::enable() {
	this->show();
	active = true;
	set_process_mode(Node::PROCESS_MODE_PAUSABLE);
	local_event_bus->enable();
}

void Entity::disable() {
	this->hide();
	active = false;
	set_process_mode(Node::PROCESS_MODE_DISABLED);
	local_event_bus->disable();
}
