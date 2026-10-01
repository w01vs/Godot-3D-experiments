#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include "event_bus_base.hpp"
#include <godot_cpp/variant/typed_dictionary.hpp>

#define register() register_component()

using namespace godot;

class Component;

class Entity : public Node3D {
    GDCLASS(Entity, Node3D)

    private:

        TypedDictionary<Script, Component> component_map;

        TypedDictionary<Script, TypedArray<Callable>> global_subscriptions;

        EventBusBase event_bus;

        bool active;

        virtual void _ready() override;

        void register_component(Ref<Component> component);
        Ref<Component> get_component(Ref<Script> script);
        bool has_component(Ref<Script> script);
        void remove_component(Ref<Component> component);

        TypedArray<Script> find_bases(Ref<Script> script);

        void subscribe();
        void unsubscribe();

        void emit_local();
        void emit_global();

        void subscribe_local();
        void subscribe_global();

        void callback_internal();

        void enable();
        void disable();
};