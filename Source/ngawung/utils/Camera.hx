package ngawung.utils;

import starling.utils.MathUtil;
import openfl.geom.Matrix;

class Camera {
    public var enable:Bool;
		
    public var x:Float;
    public var y:Float;
    public var centerX:Float;
    public var centerY:Float;
    public var rotation:Float;
    public var scaleX:Float;
    public var scaleY:Float;

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

    public function update(dt:Float):Void {
        if (!enable) return
        
        // reset matrix
        matrix.identity();
        // fake pivot
        matrix.translate( -x, -y);
        // rotate
        matrix.rotate(rotation);
        // scale
        matrix.scale(scaleX, scaleY);
        // offset
        matrix.translate(NG.game.scene.stage.stageWidth * centerX, NG.game.scene.stage.stageHeight * centerY);
        
        NG.game.scene.transformationMatrix = matrix;
    }

}