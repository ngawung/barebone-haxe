package scene.tilemap_2;

class MapConfig {
    
    public var MapData(default, null):Array<String>;
    
    public var tile_size(default, null):Int;
    public var tile_config(default, null):Array<TileConfig>;

    public function new(MapData:Array<String>, tile_size:Int, tile_config:Array<TileConfig>) {
        this.MapData = MapData;
        this.tile_size = tile_size;
        this.tile_config = tile_config;
    }

    /**
     * get texture name from TileConfig
     * return "empty" if not found
     * @return String
     */
    public function getTextureName(tileId:String):String {
        for (tc in tile_config) {
            if (tc.tileId != tileId) continue;
            return tc.textureName;
        }

        return "empty";
    }

    /**
     * get texture name from MapData
     * return "empty" if invalid
     * @return String
     */
     public function getTextureNameMap(x:Int, y:Int):String {
        if (y > MapData.length || x > MapData[0].length) return "empty";

        return getTextureName(MapData[y].charAt(x));
    }
}