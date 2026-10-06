#include "event_bus_base.hpp"
#include <godot_cpp/core/class_db.hpp>

namespace godot {

void EventBusBase::_bind_methods() {
	// Bind Methods for GDScript / Engine Access
	ClassDB::bind_method(D_METHOD("subscribe", "event_type", "callback", "conditions", "priority"), &EventBusBase::subscribe, DEFVAL(BASE));
	ClassDB::bind_method(D_METHOD("unsubscribe", "event_type", "callback"), &EventBusBase::unsubscribe);
	ClassDB::bind_method(D_METHOD("emit", "event"), &EventBusBase::emit);

	ClassDB::bind_method(D_METHOD("enable"), &EventBusBase::enable);
	ClassDB::bind_method(D_METHOD("disable"), &EventBusBase::disable);
	ClassDB::bind_method(D_METHOD("hold_events"), &EventBusBase::hold_events);
	ClassDB::bind_method(D_METHOD("release_events"), &EventBusBase::release_events);

	// Bind Enum
	BIND_ENUM_CONSTANT(PRE);
	BIND_ENUM_CONSTANT(BASE);
	BIND_ENUM_CONSTANT(POST);
}

void EventBusBase::subscribe(const Ref<Script> &p_event_type, const Callable &p_callback, const Callable &p_conditions, Priority p_priority) {
	if (p_event_type.is_null()) {
		return;
	}

	if (!listeners.has(p_event_type)) {
		Dictionary prio_dict;
		prio_dict[PRE] = TypedArray<Subscriber>();
		prio_dict[BASE] = TypedArray<Subscriber>();
		prio_dict[POST] = TypedArray<Subscriber>();
		listeners[p_event_type] = prio_dict;
	}

	Dictionary prio_dict = listeners[p_event_type];
	TypedArray<Subscriber> subs_arr = prio_dict[p_priority];

	for (int i = 0; i < subs_arr.size(); ++i) {
		Ref<Subscriber> sub_d = subs_arr[i];
		if (sub_d.is_valid() && sub_d->callback == p_callback) {
			return;
		}
	}

	// Pack subscriber into a Variant-friendly Dictionary for GDScript boundary
	Ref<Subscriber> sub;
	sub.instantiate();
	sub->callback = p_callback;
	sub->object = p_callback.get_object();
	sub->conditions = p_conditions;

	subs_arr.append(sub);
}

void EventBusBase::unsubscribe(const Ref<Script> &p_event_type, const Callable &p_callback) {
	if (!listeners.has(p_event_type)) {
		return;
	}

	Dictionary prio_dict = listeners[p_event_type];
	Array prio_keys = prio_dict.keys();

	for (int k = 0; k < prio_keys.size(); ++k) {
		int prio = prio_keys[k];
		TypedArray<Subscriber> subs_arr = prio_dict[prio];

		for (int i = subs_arr.size() - 1; i >= 0; --i) {
			Ref<Subscriber> sub = subs_arr[i];
			Callable cb = sub->callback;

			if (cb == p_callback || !cb.is_valid()) {
				subs_arr.remove_at(i);
			}
		}
	}
}

void EventBusBase::emit(const Ref<EventBaseGD> &p_event) {
	if (!active || p_event.is_null()) {
		return;
	}

	if (hold) {
		dispatch_held.append(p_event);
		return;
	}

	Ref<Script> event_type = p_event->get_script();
	if (event_type.is_null() || !listeners.has(event_type)) {
		return;
	}

	Dictionary prio_dict = listeners[event_type];
	int priorities[3] = { PRE, BASE, POST };

	for (int p = 0; p < 3; ++p) {
		int prio = priorities[p];
		if (!prio_dict.has(prio)) {
			continue;
		}

		TypedArray<Subscriber> subs_arr = prio_dict[prio];

		// Iterate backwards so dead subscriber cleanup during dispatch is safe
		for (int i = subs_arr.size() - 1; i >= 0; --i) {
			Ref<Subscriber> sub = subs_arr[i];
			Callable cb = sub->callback;
			Callable cond = sub->conditions;

			if (cb.is_valid() && cond.is_valid()) {
				Variant cond_res = cond.call();
				if (bool(cond_res)) {
					cb.call(p_event);
				}
			} else {
				subs_arr.remove_at(i);
			}
		}
	}
}

bool EventBusBase::_has_callback(const TypedArray<Subscriber> &p_subs, const Callable &p_cb) const {
	for (const Ref<Subscriber> sub : p_subs) {
		if (sub->callback == p_cb) {
			return true;
		}
	}
	return false;
}

void EventBusBase::_emit_held() {
	for (int i = 0; i < dispatch_held.size(); ++i) {
		Ref<Subscriber> ev = dispatch_held[i];
		emit(ev);
	}
	dispatch_held.clear();
}

void EventBusBase::release_events() {
	hold = false;
	_emit_held();
}

} // namespace godot