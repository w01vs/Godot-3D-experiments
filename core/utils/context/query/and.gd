class_name AndQuery extends ContextQuery

@export var queries: Array[ContextQuery]

func _init(queries_: Array[ContextQuery] = []) -> void:
	queries = queries_

func add_query(query: ContextQuery) -> void:
	queries.append(query)

func validate() -> bool:
	var res: bool = true
	for query in queries:
		res = res && query.validate()
	return res
