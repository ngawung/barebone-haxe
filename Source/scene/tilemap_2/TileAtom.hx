package scene.tilemap_2;

import ngawung.utils.Camera;
import ngawung.core.MainEngine;
import starling.display.Image;

class TileAtom extends Image {
    private var _ng(get, null):MainEngine;
    
    public var tile_pos(default, null):String;
    public var tile_id(default, null):String;

    public function new(tilePos:String, tileId:String = "-1", texture:String = "empty") {
        super(_ng.assetManager.getTexture(texture));

        tile_pos = tilePos;
        tile_id = tileId;
    }

    public function isInBound(camX:Float, camY:Float, sW:Int, sH:Int):Bool {
        // return (x + width > camX || x < camX + sW || y + height > camY || y < camY + sH);
        return ((x + width >= camX && y + height >= camY) && (x <= camX + sW && y <= camY + sH));
    }

    public function destroy(removeFromParent:Bool = false):Void {
        
    }

    // ###########

    public function setTo(tilePos:String, tileId:String, texture:String) {
        this.texture = _ng.assetManager.getTexture(texture);
        
        tile_pos = tilePos;
        tile_id = tileId;
    }

    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
}