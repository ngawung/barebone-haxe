package ngawung.input;

import ngawung.core.MainEngine;
import starling.events.KeyboardEvent;
import openfl.Vector;

class Input {
    private var _ng:MainEngine;
    private var enable:Bool; // this input class is global and should not disabled...
    public var keyState:Vector<Int>;

    public function new() {
        _ng = MainEngine.instance;

        enable = true;
        keyState = new Vector<Int>(256, true);

        addListener();
    }

    private function addListener():Void {
        _ng.gameRoot.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _ng.gameRoot.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    // Updated by Game engine
    public function update(dt:Float):Void {
        if (!enable) return;
        for (i in 0...keyState.length) {
            if (keyState[i] != 0) keyState[i]++;
        }
    }

    private function onKeyDown(e:KeyboardEvent):Void {
        var code:Int = e.keyCode;
        if (code > keyState.length || code < 0) return;

        // update keys, set keyState to 1 or >1 if hold
        keyState[code] = Std.int(Math.max(keyState[code], 1));
    }

    private function onKeyUp(e:KeyboardEvent):Void {
        var code:Int = e.keyCode;
        if (code > keyState.length || code < 0) return;

        // set keyState to -1
        keyState[code] = -1;
    }

    // get key status
    public function isHeld(code:Int):Bool {
        return keyState[code] > 0;
    }
    
    public function isDown(code:Int):Bool {
        return keyState[code] == 1;
    }
    
    public function isReleased(code:Int):Bool {
        return keyState[code] == -1;
    }

}