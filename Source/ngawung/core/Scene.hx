package ngawung.core;

import ngawung.display.Atom;
import starling.display.DisplayObject;
import ngawung.utils.Camera;
import starling.display.Sprite;

class Scene extends Sprite {
    private var _ng(get, null):MainEngine;
    public var game(get, null):Game;

    public var camera:Camera;

    public function new() {
        super();
    
    }

    public function PreInit():Void {
        camera = new Camera();

        // init physic

        init();
    }
    
    // Engine update
    public function preUpdate(dt:Float):Void {
        // update physic

        // update child that implement atom
        for (child in __children) {
            if (Std.isOfType(child, Atom)) cast(child, Atom).update(dt);
        }

        update(dt);
    }

    public function init():Void {
        
    }

    public function update(dt:Float):Void {
        
    }

    public function destroy(dispose:Bool = false):Void {
        camera.destroy();
        // destroy physic

        removeFromParent(dispose);
    }

    // override fun
    

    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
    private function get_game():Game { return _ng.gameRoot; }

}