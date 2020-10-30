package scene.tilemap_2;

import ngawung.core.MainEngine;
import starling.display.Image;
import ngawung.display.Atom;

class TileAtom extends Image implements Atom {
    private var _ng(get, null):MainEngine;
    public var TileId(default, null):String;

    public function new(config:TileConfig) {
        super(_ng.assetManager.getTexture(config.textureName));
        TileId = config.tileId;
    }

    public function update(dt:Float):Void {

    }

    public function destroy(removeFromParent:Bool = false):Void {
        
    }

    public function resize():Void {
        
    }

    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
}