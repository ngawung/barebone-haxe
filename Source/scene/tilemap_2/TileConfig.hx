package scene.tilemap_2;

typedef TileObject = { 
    var TileId:String;
    var TextureName:String;
    var isAnimated:Bool;
}

class TileConfig {
    public var ConfigArray:Array<TileObject> = [];

    public function new() {

    }

    public function add(TileId:String, TextureName:String, isAnimated:Bool = false) {
        ConfigArray.push({ TileId: TileId, TextureName: TextureName, isAnimated: isAnimated });
    }

    /**
     * return TileObject from TileConfig array.
     * return null if invalid.
     * @return TileObject
     */
    public function getTileConfig(TileId:String):TileObject {
        for (obj in ConfigArray) {
            if (obj.TileId != TileId) continue;
            return obj;
        }

        return null;
    }

}