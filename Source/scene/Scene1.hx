package scene;

import openfl.ui.Keyboard;
import starling.events.Touch;
import starling.display.Quad;
import starling.events.TouchPhase;
import starling.events.TouchEvent;
import starling.display.Image;
import ngawung.NGScene;

class Scene1 extends NGScene {

    private var img:Quad;

    public function new() {
        super();

    }

    override public function init():Void {
        trace(stage.stageWidth, stage.stageHeight);
        
        img = new Image(NG.assets.getTexture("openfl"));
        img.scale = 0.3;
        img.x = stage.stageWidth / 2 - img.width / 2;
        img.y = stage.stageHeight / 2 - img.height / 2;
        addChild(img);

        img.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    override public function update(dt:Float):Void {
        if (NG.getInput().isReleased(Keyboard.ENTER)) {
            NG.getRoot().scene(new Scene2());
        }

        //trace(NG.getInput().keyState[Keyboard.ENTER]);
    }

    public function onTouch(e:TouchEvent):Void {
        var t:Touch = e.getTouch(img, TouchPhase.ENDED);
        
        if (t != null) {
            NG.getRoot().scene(new Scene2());
        }
    }


}