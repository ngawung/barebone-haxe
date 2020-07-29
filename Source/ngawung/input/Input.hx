package ngawung.input;

import starling.events.KeyboardEvent;
import openfl.Vector;

class Input {
    public var keyState:Vector<Int>;

    public function new() {
        keyState = new Vector<Int>(256, true);

        addListener();
    }

    private function addListener():Void {
        NG.game.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        NG.game.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    // Updated by Game engine
    public function update(dt:Float):Void {
        for (i in 0...keyState.length) {
            if (keyState[i] != 0) keyState[i]++;
        }
    }

    private function onKeyDown(e:KeyboardEvent):Void {
        var code:Int = e.keyCode;
        // update keys, set keyState to 1 or >1 if hold
        keyState[code] = Std.int(Math.max(keyState[code], 1));
    }

    private function onKeyUp(e:KeyboardEvent):Void {
        // set keyState to -1
        keyState[e.keyCode] = -1;
    }

    // get key status
    public function isDown(code:Int):Bool {
        return keyState[code] > 0;
    }
    
    public function isPressed(code:Int):Bool {
        return keyState[code] == 1;
    }
    
    public function isReleased(code:Int):Bool {
        return keyState[code] == -1;
    }

}