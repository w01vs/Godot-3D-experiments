#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/script.hpp>
#include <godot_cpp/variant/dictionary.hpp>

using namespace godot;

class EventBaseGD : public Resource {
	GDCLASS(EventBaseGD, Resource)

protected:
	Node *source = nullptr;
	uint64_t debug_id = 0;
	static void _bind_methods();

public:
	EventBaseGD() = default;
	~EventBaseGD() = default;

	static Ref<EventBaseGD> create(Node *p_source);

	void set_source(Node *p_source) { source = p_source; }
	Node *get_source() const { return source; }

	uint64_t get_debug_id() const { return debug_id; }
	void set_debug_id(uint64_t p_debug_id) { debug_id = p_debug_id; }

	static bool validate_event_script(const Variant& event_type);
};