
extends TileMap

#Choose parent Node
onready var map = get_parent()

#Run
func _ready():
	var objects = get_objects("res://scenes/tileset-spawners.tscn")
	build_tilemap(self, objects, map)

	
func get_objects(tileset_path):
	var tileset = load(tileset_path).instance()
	
	var rs = {}
	for child in tileset.get_children():
		rs[child.get_name()] = child
	
	return rs

func build_tilemap(tilemap, objects, parent=tilemap,keep_tiles=false):
	var id = tilemap.get_cell( 0, 0)
	
	for pos in tilemap.get_used_cells():
		var tileID = tilemap.get_cellv(pos)
		var name = tilemap.get_tileset().tile_get_name(tileID)
		var world_pos = tilemap.map_to_world(pos)
		var obj_class
		var obj
		
		for key in objects:
			print(name)
			if(name == key):
				if( typeof(objects[key])==TYPE_STRING ):
					obj_class = load( objects[key] )
					obj = obj_class.instance()
				else:
					print(objects[key])
					obj = load( objects[key].get_filename() ).instance()
				
				# apply tilemap node offset
				world_pos+=tilemap.get_pos()
					
				#tile origin - cant see any difference
				if( tilemap.get_tile_origin()==tilemap.TILE_ORIGIN_TOP_LEFT ):
					# apply center
					world_pos.x+=tilemap.get_cell_size().x/2#obj.get_texture().get_width()/2
					world_pos.y+=tilemap.get_cell_size().y/2##obj.get_texture().get_height()/2

				elif( tilemap.get_tile_origin()==tilemap.TILE_ORIGIN_CENTER ):
					# apply center
					world_pos.x+=tilemap.get_cell_size().x/2#obj.get_texture().get_width()/2
					world_pos.y+=tilemap.get_cell_size().y/2##obj.get_texture().get_height()/2

				#flip - looks strange but is working
				var x_flipped = tilemap.is_cell_x_flipped( pos.x,pos.y )
				var y_flipped = tilemap.is_cell_y_flipped( pos.x,pos.y )
					
				if(tilemap.is_cell_transposed( pos.x,pos.y )):
					if( x_flipped && !y_flipped):
						obj.set_rot(deg2rad(-90))
					elif(y_flipped && !x_flipped):
						obj.set_rot(deg2rad(90))
					elif(x_flipped && y_flipped):
						obj.set_rot(deg2rad(90))
						obj.set_flip_v( y_flipped )
				else:
					obj.set_flip_h( x_flipped )
					obj.set_flip_v( y_flipped )
				
				#y sort
				#if( tilemap.is_y_sort_mode_enabled() ):
				#	obj.set_z( world_pos.y )

				# TODO ...
				
				obj.set_pos( world_pos )
				parent.call_deferred("add_child", obj )
				
	#remove to test transformation
	if( !keep_tiles ):
		if(tilemap==parent):
			tilemap.clear()
		else:
			tilemap.queue_free()
	else:
		tilemap.hide()
