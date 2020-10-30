package scene.tilemap_2;

import ngawung.core.MainEngine;
import starling.textures.Texture;
import starling.display.Image;
import ngawung.display.Atom;

class TileAtom extends Image implements Atom {
    private var _ng(get, null):MainEngine;
    public var TileId(default, null):String;

    public function new(TileId:String) {
        super(getTexture(TileId));

        this.TileId = TileId;
    }

    public function update(dt:Float):Void {

    }

    public function destroy():Void {

    }

    private function getTexture(id:String):Texture {
        switch (id) {
            case ".": return _ng.assetManager.getTexture("tile2");
            case "#": return _ng.assetManager.getTexture("tile1");
            case "1": return _ng.assetManager.getTexture("1");
            case "2": return _ng.assetManager.getTexture("2");
            case "3": return _ng.assetManager.getTexture("3");
            case "4": return _ng.assetManager.getTexture("4");
            case "5": return _ng.assetManager.getTexture("5");
            case "6": return _ng.assetManager.getTexture("6");
            case "7": return _ng.assetManager.getTexture("7");
            case "8": return _ng.assetManager.getTexture("8");
            case "9": return _ng.assetManager.getTexture("9");

            default: return _ng.assetManager.getTexture("tile2");
        }
    }

    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
}