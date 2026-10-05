#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include "event/event_bus_base.hpp"
#include <godot_cpp/variant/typed_dictionary.hpp>
#include <cassert>
#include <godot_cpp/variant/typed_array.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include "event/global_event.hpp"
#include "event/entity_event.hpp"
#include "event/event_bus.hpp"

using namespace godot;

class Component;

class Entity : public Node3D {
    GDCLASS(Entity, Node3D)

    private:
        Entity();
        ~Entity() = default;

        TypedDictionary<Script, Component> component_map;

        TypedDictionary<Script, TypedArray<Callable>> global_subscriptions;

        EventBusBase local_event_bus;

        Ref<Script> entity_event_script;

        bool active;

        virtual void _ready() override;

        void register_component(const Ref<Component>& component);
        Ref<Component> get_component(const Ref<Script>& script);
        bool has_component(const Ref<Script>& script);
        void remove_component(const Ref<Component>& component);

        TypedArray<Script> find_bases(const Ref<Script>& p_script, bool removing = false);

        void subscribe(const Ref<Component>& component, const Ref<Script>& event_type, const Ref<Callable>& callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE);
        void unsubscribe(const Ref<Script>& event_type, const Ref<Callable>& callback);

        void emit_local(const Ref<EntityEventGD>& event);
        void emit_global(const Ref<GlobalEventGD>& event);

        void subscribe_global(const Ref<Component>& component, const Ref<Script>& event_type, const Ref<Callable>& callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE);
        void unsubscribe_global(const Ref<Script>& event_type, const Ref<Callable>& callback);

        void callback_internal(const Ref<EventBase>& event);

        void enable();
        void disable();
};