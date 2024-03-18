extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var region_rid: RID = NavigationServer2D.region_create()
	var map_rid: RID = get_region_rid()
	NavigationServer2D.region_set_map(region_rid, map_rid)
	NavigationServer2D.region_set_navigation_layers(map_rid, 4)

