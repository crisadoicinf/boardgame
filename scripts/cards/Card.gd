extends Object

var itemId: String


func _init(itemId: String):
	self.itemId = itemId


func get_item_id() -> String:
	return itemId


func is_resource(resource: Resource) -> bool:
	return resource.get_path() == get_script().get_path()
