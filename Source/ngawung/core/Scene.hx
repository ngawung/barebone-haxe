package ngawung.core;

import ngawung.input.Input;
import ngawung.display.Atom;
import starling.display.DisplayObject;
import ngawung.utils.Camera;
import starling.display.Sprite;

class Scene extends Sprite {
    private var _ng(get, null):MainEngine;
    public var game(get, null):Game;
    public var input(get, null):Input;

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

    public function preResize():Void {
        // resize child that implement atom
        for (child in __children) {
            if (Std.isOfType(child, Atom)) cast(child, Atom).resize();
        }

        resize();
    }

    public function cameraPreUpdate():Void {
        cameraUpdate();
    }

    // ###############

    public function init():Void {
        
    }

    public function update(dt:Float):Void {
        
    }

    public function resize():Void {
        
    }

    public function cameraUpdate():Void {
        
    }

    public function destroy(dispose:Bool = false):Void {
        camera.destroy();
        // destroy physic

        removeFromParent(dispose);
    }

    // ###############
    

    // override function

    override function removeChildAt(index:Int, dispose:Bool = false):DisplayObject {
        // destroy child that implement Atom
        var child:DisplayObject = getChildAt(index);
        if (Std.isOfType(child, Atom)) cast(child, Atom).destroy();
        
        return super.removeChildAt(index, dispose);
    }
    
    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
    private function get_game():Game { return _ng.gameRoot; }
    private function get_input():Input { return game.input; }

}