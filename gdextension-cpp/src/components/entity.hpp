#pragma once

#include "event/entity_event.hpp"
#include "event/event_bus_base.hpp"
#include "event/global_event.hpp"
#include <cassert>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/typed_array.hpp>
#include <godot_cpp/variant/typed_dictionary.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

class Component;

class Entity : public Node3D {
	GDCLASS(Entity, Node3D)
public:
    void register_component(const Component* component);
    Component* get_component(const Ref<Script> &script);
    bool has_component(const Ref<Script> &script);
    void remove_component(const Component* component);
    virtual void _ready() override;
protected:
    static void _bind_methods();

private:
	Entity();
	~Entity() = default;

	TypedDictionary<Script, Component> component_map;

	TypedDictionary<Script, Array> global_subscriptions;

	EventBusBase local_event_bus;

	Ref<Script> entity_event_script;

	bool active;



	TypedArray<Script> find_bases(const Ref<Script> &p_script, bool removing = false);

	void subscribe(Component* component, const Ref<Script> &event_type, const Callable &callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE);
	void unsubscribe(const Ref<Script> &event_type, const Callable &callback);

	void emit_local(const Ref<EntityEventGD> &event);
	void emit_global(const Ref<GlobalEventGD> &event);

	void subscribe_global(const Component* component, const Ref<Script> &event_type, const Callable &callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE);
	void unsubscribe_global(const Ref<Script> &event_type, const Callable &callback);

	void callback_internal(const Ref<EventBase> &event);

	void enable();
	void disable();
};