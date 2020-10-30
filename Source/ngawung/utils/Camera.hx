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

        _ng.gameRoot.scene.cameraPreUpdate();
    }

    /**
     * Output warn when set camera variable but camera not enable yet
     */
    private function warnCamera():Void {
        if (!enable) trace("[WARNING] Camera not enable yet!");
    }

    // GET && SET

    private function set_x(value:Float):Float {
        warnCamera(); 
        x = value;
        update();
        return x;
    }

    private function set_y(value:Float):Float {
        warnCamera();
        y = value;
        update();
        return y;
    }

    private function set_centerX(value:Float):Float {
        warnCamera();
        centerX = value;
        update();
        return centerX;
    }

    private function set_centerY(value:Float):Float {
        warnCamera();
        centerY = value;
        update();
        return centerY;
    }

    private function set_rotation(value:Float):Float {
        warnCamera();
        rotation = value;
        update();
        return rotation;
    }

    private function set_scaleX(value:Float):Float {
        warnCamera();
        scaleX = value;
        update();
        return scaleX;
    }

    private function set_scaleY(value:Float):Float {
        warnCamera();
        scaleY = value;
        update();
        return scaleY;
    }
    
    private function get__ng():MainEngine { return MainEngine.instance; }

}