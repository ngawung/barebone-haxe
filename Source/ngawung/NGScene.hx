package ngawung;

import ngawung.utils.Camera;
import starling.display.Sprite;

class NGScene extends Sprite {
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
        camera.update(dt);
        // update physic

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

}