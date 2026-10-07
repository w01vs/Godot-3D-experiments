#pragma once

#include "entity.hpp"
#include "event/event_bus_base.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include <cassert>
#include <godot_cpp/core/gdvirtual.gen.inc>

using namespace godot;

class Component : public Node {
	GDCLASS(Component, Node)

private:
	Entity *entity = nullptr;
	bool active = true;

protected:
	static void _bind_methods();
	virtual void _on_entity_load();
	GDVIRTUAL0(_on_entity_load);
	virtual void _init_component();
	GDVIRTUAL0(_init_component);
	void _notification(int what);

public:
	Component() = default;
	~Component() = default;
	bool is_active() { return active; }
	Entity *get_entity() const { return entity; }
	void set_entity(Entity *p_entity) { entity = p_entity; }
	void _ready() override;
	void enable();
	virtual void _on_enable();
	GDVIRTUAL0(_on_enable);
	void disable();
	virtual void _on_disable();
	GDVIRTUAL0(_on_disable);

	void subscribe(const Variant &event_type, Callable callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE);
	void emit(Ref<EventBaseGD> event);
	const static char *GROUP;
};
