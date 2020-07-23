package ngawung;

import starling.display.Sprite;

class NGScene extends Sprite {

    public function new() {
        super();

    }

    public function init():Void {
        // init camera
        // init physic
    }
    
    // Engine update
    public function preUpdate(dt:Float):Void {
        // update camera
        // update physic

        update(dt);
    }

    public function update(dt:Float):Void {
        
    }

    public function destroy(dispose:Bool = false):Void {
        // destroy camera
        // destroy physic

        removeFromParent(dispose);
    }

}