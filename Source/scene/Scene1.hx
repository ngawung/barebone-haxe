package scene;

import starling.utils.MathUtil;
import ngawung.core.MainEngine;
import ngawung.display.Atom;
import ngawung.core.Scene;
import openfl.ui.Keyboard;
import starling.events.Touch;
import starling.display.Quad;
import starling.events.TouchPhase;
import starling.events.TouchEvent;
import starling.display.Image;

class Scene1 extends Scene {

    private var img:Quad;

    public function new() {
        super();

    }

    override public function init():Void {
        var q:Quad = new Quad(3, stage.stageHeight, 0xFF00D2);
        q.x = stage.stageWidth / 2 - q.width / 2;
        addChild(q);
        
        var q2:Quad = new Quad(stage.stageWidth, 3, 0xFF00D2);
        q2.y = stage.stageHeight / 2 - q2.height / 2;
        addChild(q2);

        img = new MyImage();
        img.pivotX = (img.width )/ 2;
        img.pivotY = (img.height )/ 2;
        img.x = stage.stageWidth / 2;
        img.y = stage.stageHeight / 2;
        img.scale = 0.3;
        addChild(img);

        img.addEventListener(TouchEvent.TOUCH, onTouch);

        camera.enable = true;
    }

    override public function update(dt:Float):Void {
        if (game.input.isReleased(Keyboard.ENTER)) {
            game.scene = new Scene2();
        }
        
        if (game.input.isDown(Keyboard.W)) camera.y -= 1;
        if (game.input.isDown(Keyboard.S)) camera.y += 1;
        if (game.input.isDown(Keyboard.D)) camera.x += 1;
        if (game.input.isDown(Keyboard.A)) camera.x -= 1;

        //trace(NG.getInput().keyState[Keyboard.ENTER]);
    }

    public function onTouch(e:TouchEvent):Void {
        var t:Touch = e.getTouch(img, TouchPhase.ENDED);
        
        if (t != null) {
            game.scene = new Scene2();
        }
    }


}

class MyImage extends Image implements Atom {
    public var layer:Int;

    public function new() {
        super(MainEngine.instance.assetManager.getTexture("openfl"));
    }

    public function init():Void {

    }
    public function update(dt:Float):Void {
        this.rotation += MathUtil.deg2rad(1);
    }

    public function destroy():Void {

    }
}