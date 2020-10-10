package scene;

import openfl.ui.Keyboard;
import starling.events.TouchPhase;
import starling.events.TouchEvent;
import starling.display.Image;
import ngawung.core.Scene;

class Scene2 extends Scene {

    private var img:Image;

    public function new() {
        super();

    }

    override public function init():Void {
        img = new Image(_ng.assetManager.getTexture("logonav"));
        img.scale = 0.3;
        img.x = stage.stageWidth / 2 - img.width / 2;
        img.y = stage.stageHeight / 2 - img.height / 2;
        addChild(img);

        img.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    override public function update(dt:Float):Void {
        if (game.input.isReleased(Keyboard.ENTER)) {
            game.scene = new Scene1();
        }
    }

    public function onTouch(e:TouchEvent):Void {
        if (e.getTouch(img, TouchPhase.ENDED) != null) {
            game.scene = new Scene1();
        }
    }


}