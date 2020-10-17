package ngawung.utils;

import ngawung.core.MainEngine;
import starling.utils.MathUtil;
import openfl.geom.Matrix;

class Camera {
    private var _ng(get, null):MainEngine;

    public var enable:Bool;
		
    public var x(default, set):Float = 0;
    public var y(default, set):Float = 0;
    public var centerX(default, set):Float = 0;
    public var centerY(default, set):Float = 0;
    public var rotation(default, set):Float = 0;
    public var scaleX(default, set):Float = 1;
    public var scaleY(default, set):Float = 1;

    private var matrix:Matrix = new Matrix();

    public function new() {
        enable = false;
        x = 0;
        y = 0;
        centerX = 0;
        centerY = 0;
        rotation = 0;
        scaleX = 1;
        scaleY = 1;
    }

    public function setTo(x:Float, y:Float):Void {
        this.x = x;
        this.y = y;
    }

    public function rotate(angle:Float, convertToRadian:Bool = true):Void {
        if (convertToRadian) rotation = MathUtil.deg2rad(angle);
        else rotation = angle;
    }

    public function zoom(zoom:Float):Void {
        if ((scaleX + zoom) <= 0 || (scaleY + zoom) <= 0)
            throw "Cannot scale to less than 0";
        
        scaleX += scaleX;
        scaleY += scaleY;
    }

    public function setup(x:Float = 0, y:Float = 0, centerX:Float = 0.5, centerY:Float = 0.5):Void {
        this.x = x;
        this.y = y;
        this.centerX = centerX;
        this.centerY = centerY;
        
        enable = true;
    }

    public function destroy():Void {
        // just in case if i add something...
    }

    private function update():Void {
        if (!enable) return;
        
        // reset matrix
        matrix.identity();
        // fake pivot
        matrix.translate( -x, -y);
        // rotate
        matrix.rotate(rotation);
        // scale
        matrix.scale(scaleX, scaleY);
        // offset
        matrix.translate(_ng.gameRoot.scene.stage.stageWidth * centerX, _ng.gameRoot.scene.stage.stageHeight * centerY);
        
        if (_ng.gameRoot.scene.transformationMatrix.toString() == matrix.toString()) return;
        _ng.gameRoot.scene.transformationMatrix = matrix;
    }

    // GET && SET

    private function set_x(value:Float):Float { 
        x = value;
        update();
        return x;
    }

    private function set_y(value:Float):Float { 
        y = value;
        update();
        return y;
    }

    private function set_centerX(value:Float):Float { 
        centerX = value;
        update();
        return centerX;
    }

    private function set_centerY(value:Float):Float { 
        centerY = value;
        update();
        return centerY;
    }

    private function set_rotation(value:Float):Float { 
        rotation = value;
        update();
        return rotation;
    }

    private function set_scaleX(value:Float):Float { 
        scaleX = value;
        update();
        return scaleX;
    }

    private function set_scaleY(value:Float):Float { 
        scaleY = value;
        update();
        return scaleY;
    }
    
    private function get__ng():MainEngine { return MainEngine.instance; }

}