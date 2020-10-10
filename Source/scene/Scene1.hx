package scene;

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
        img = new Image(_ng.assetManager.getTexture("openfl"));
        img.scale = 0.3;
        img.x = stage.stageWidth / 2 - img.width / 2;
        img.y = stage.stageHeight / 2 - img.height / 2;
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