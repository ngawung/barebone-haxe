package scene.tilemap_2;

class TileConfig {
    public var tileId(default, null):String;
    public var textureName(default, null):String;

    public var isAnimated(default, null):Bool;

    public function new(tileId:String = "-1", textureName:String = "empty", isAnimated:Bool = false) {
        this.tileId = tileId;
        this.textureName = textureName;
        this.isAnimated = isAnimated;
    }
}