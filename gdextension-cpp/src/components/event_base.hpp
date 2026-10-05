#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/script.hpp>

using namespace godot;

class EventBase : public Resource {
    GDCLASS(EventBase, Resource)

    private:
        Ref<Node> source;
        uint64_t debug_id = 0;
    
    protected:
        static void _bind_methods();
    public:
        EventBase() = default;
        ~EventBase() = default;

        static Ref<EventBase> create(Ref<Node> p_source);

        void set_source(Ref<Node> p_source) { source = p_source; };
        Ref<Node> get_source() const { return source; };

        uint64_t get_debug_id() const { return debug_id; }


};