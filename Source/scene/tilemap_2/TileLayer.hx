package scene.tilemap_2;

import starling.events.Event;
import flash.display.Sprite;

class TileLayer extends Sprite {
    public var config(default, null):MapConfig;
    
    public function new(config:MapConfig) {
        super();
        this.config = config;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);


    }
}