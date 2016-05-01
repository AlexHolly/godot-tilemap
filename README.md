#Tut

1.Copy this script to your Project folder
2.Add this script as autoload and leave the name as tilemap
	Scene -> Projects Settings -> Autoload
3.Create a TileMap Node and add a new script to this Node.
	
4.


#Modes

Tileset - Use your Tileset Scene as objects source. -> Adds the Root Node children as objects
Scene - Use your Scene as objects source. -> Adds the Root Node as object, add multible Scenes with a dictionary ["name"] = PATH

#Example - Scene Mode

```
extends TileMap

#Choose parent Node
onready var map = get_parent().get_node("Map")

#Define objects
var objects = {
	"Brick":"res://scenes/brick.scn",
	"Wall":"res://scenes/wall.scn"

}

#Run
func _ready():
	tilemap.build_tilemap(self, objects, map)

```


#Example - Tileset Mode

```
extends TileMap

#Choose parent Node
onready var map = get_parent().get_node("Map")

#Run
func _ready():
	var objects = tilemap.get_objects("res://tilesetscene.tscn")
	tilemap.build_tilemap(self, objects, map)

```

#Other
-You can also use the TileMap Node as map(parent Node for created objects) 
	```tilemap.build_tilemap(self, objects)```

-Use multible Tilemap Nodes each is one layer to get z sort.


#ISSUES

- The Tileset mode is executing _ready twice. It also breaks usage of get_name() (if duplucate Scenes are used) because each instance will get an incremented ID. 
 -> workaround use the id ad name -> export(String,"wall","brick","brick2") var id
- Sometimes create TileSet merge or not merge is not working.
- Each Sprite needs his own name otherwise the tileset will show wrong stuff

#TODO
- y sort
- rotation

#Supports
- isometric/square mode

