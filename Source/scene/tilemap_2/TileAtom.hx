package scene.tilemap_2;

import ngawung.core.MainEngine;
import starling.display.Image;
import ngawung.display.Atom;

class TileAtom extends Image implements Atom {
    private var config:TileConfig;

    private var _ng(get, null):MainEngine;
    public var TileId(default, null):String;

    public function new(config:TileConfig = null) {
        if (config == null) this.config = new TileConfig();
        this.config = config;

        super(_ng.assetManager.getTexture(this.config.textureName));
        TileId = this.config.tileId;

    }

    public function update(dt:Float):Void {

    }

    public function destroy(removeFromParent:Bool = false):Void {
        
    }

    public function resize():Void {
        
    }

    // ###########

    public function setTo(config:TileConfig) {
        this.texture = _ng.assetManager.getTexture(config.textureName);
        this.TileId = config.tileId;
        this.config = config;
    }

    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
}