#pragma once

#include "event_base.hpp"
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/script.hpp>
#include <godot_cpp/variant/callable.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/typed_array.hpp>
#include <godot_cpp/variant/typed_dictionary.hpp>

namespace godot {

class EventBusBase : public RefCounted {
	GDCLASS(EventBusBase, RefCounted)

public:
	enum Priority {
		PRE = 0,
		BASE = 1,
		POST = 2
	};

	class Subscriber : public RefCounted {
		GDCLASS(Subscriber, RefCounted)
	public:
		Subscriber() = default;

	protected:
		static void _bind_methods() {}

	private:
		Subscriber(const Callable &p_cb, const Callable &p_cond) : callback(p_cb), conditions(p_cond) {
			object = p_cb.get_object();
		}
		Callable callback;
		Callable conditions;
		Object *object = nullptr;

		friend class EventBusBase;
	};

private:
	TypedDictionary<Script, Dictionary> listeners;

	bool active = true;
	bool hold = false;
	TypedArray<EventBase> dispatch_held;

	bool _has_callback(const TypedArray<Subscriber> &p_subs, const Callable &p_cb) const;
	void _emit_held();

protected:
	static void _bind_methods();

public:
	EventBusBase() = default;
	~EventBusBase() = default;

	void subscribe(const Ref<Script> &p_event_type, const Callable &p_callback, const Callable &p_conditions, Priority p_priority = BASE);
	void unsubscribe(const Ref<Script> &p_event_type, const Callable &p_callback);
	void emit(const Ref<EventBase> &p_event);

	void enable() { active = true; }
	void disable() { active = false; }
	void hold_events() { hold = true; }
	void release_events();

	bool is_active() const { return active; }
	bool is_holding() const { return hold; }
};

} // namespace godot

VARIANT_ENUM_CAST(EventBusBase::Priority);
