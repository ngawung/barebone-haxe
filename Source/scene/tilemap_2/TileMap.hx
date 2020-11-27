package scene.tilemap_2;

class TileMap {

    public var MapArray:Array<String>;
    public var TileSize:Int;

    public function new(MapArray:Array<String>, TileSize:Int) {
        this.MapArray = MapArray;
        this.TileSize = TileSize;
    }

    /**
     * return TileId from map position.
     * return -1 if invalid.
     * @return String
     */
    public function getMapFromPos(posX:Int, posY:Int):String {
        if (posY >= MapArray.length || posX >= MapArray[0].length || posY < 0 || posX < 0) return "-1";

        return MapArray[posY].charAt(posX);
    }

    /**
     * return TileId from raw coord.
     * return -1 if invalid.
     * @return String
     */
     public function getMapFromCoord(posX:Float, posY:Float):String {
        return getMapFromPos(Std.int(Math.floor(posX / TileSize)), Std.int(Math.floor(posY / TileSize)));
    }

}