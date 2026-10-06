#pragma once

#include "entity.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include <cassert>
#include <godot_cpp/core/gdvirtual.gen.inc>

using namespace godot;

class Component : public Node {
	GDCLASS(Component, Node)

	friend class Entity;

private:
	Entity* entity;
	bool active = true;

protected:
	static void _bind_methods();
	virtual void _on_entity_load();
	GDVIRTUAL0(_on_entity_load);

public:
	Component() = default;
	~Component() = default;
	bool is_active() { return active; }
	const Entity* get_entity() { return entity; }
	void _ready() override;
};
