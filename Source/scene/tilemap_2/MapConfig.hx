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
}