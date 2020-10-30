package scene.tilemap_2;

class MapConfig {
    
    public var MapData(default, null):Array<String>;
    
    public var tile_size(default, null):Int;
    public var tile_config(default, null):Array<TileConfig>;

    public function new() {

    }
}