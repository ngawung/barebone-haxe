package scene;

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
        
        //img = new Image(NG.assets.getTexture("openfl"));
        //img.scale = 0.3;
        img = new Quad(stage.stageWidth,stage.stageHeight,0xFFFFFF);
        //img.pivotX = 100;
        //img.x = stage.stageWidth / 2; //- img.width / 2;
        //img.y = stage.stageHeight / 2; //- img.height / 2;
        addChild(img);

        addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function onTouch(e:TouchEvent):Void {
        var t:Touch = e.getTouch(this, TouchPhase.ENDED);
        
        if (t != null) {
            trace(t.globalX, t.globalY);
        }
    }


}