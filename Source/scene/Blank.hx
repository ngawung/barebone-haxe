package scene;

import starling.events.Touch;
import starling.events.TouchPhase;
import openfl.ui.Keyboard;
import openfl.events.TextEvent;
import openfl.events.Event;
import openfl.text.TextFormat;
import openfl.events.FocusEvent;
import openfl.text.TextFieldType;
import starling.events.TouchEvent;
import haxe.PosInfos;
import haxe.Log;
import starling.text.TextFieldAutoSize;
import starling.utils.Align;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.display.Quad;
import starling.display.Sprite;
import ngawung.core.Scene;

class Blank extends Scene {

    private var console:Sprite = new Sprite();
    private var console_bg:Quad = new Quad(10, 10, 0x000000);
    private var console_text:TextField = new TextField(0, 0, "");
    private var console_input:Quad = new Quad(10, 10, 0xFFFFFF);
    private var console_inputtext:TextField = new TextField(0, 0, "");

    private var isFocus:Bool = false;

    public function new() {
        super();

    }

    override function init() {
        init_console();

        var oldTrace = Log.trace;
        Log.trace = function (v:Dynamic, ?info:PosInfos) {
            oldTrace(v, info);
            // console_text.text += '[${info.fileName}:${info.lineNumber}] ${v}\n';
            console_text.text += Log.formatOutput(v, info) + "\n";
            console_text.y = stage.stageHeight - console_text.height - console_input.height - 15;
        }

        trace("init");
    }

    override function update(dt:Float) {
        
        if (input.isDown(Keyboard.BACKQUOTE)) console.visible = !console.visible;

    }

    // ####

    private function init_console():Void {
        console_bg.width = stage.stageWidth;
        console_bg.height = stage.stageHeight;

        console_text.format.setTo(BitmapFont.MINI, 16, 0xFFFFFF, Align.LEFT, Align.TOP);
        console_text.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        console_text.x = 5;

        console_input.width = stage.stageWidth;
        console_input.height = 20;
        console_input.y = stage.stageHeight - console_input.height;
        console_input.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
            if (e.getTouch(console_input, TouchPhase.ENDED) == null || isFocus) return;
            
            var t:flash.text.TextField = new flash.text.TextField();
            t.type = TextFieldType.INPUT;
            t.width = console_input.width;
            t.height = console_input.height;
            t.multiline = false;
            t.sharpness = 0;
            t.y = console_input.y;
            t.text = console_inputtext.text;
            t.setSelection(t.text.length, t.text.length);
            console_inputtext.visible = false;

            t.addEventListener(FocusEvent.FOCUS_OUT, function(e:FocusEvent) {
                console_inputtext.visible = true;
                console_inputtext.text = t.text;
                console_inputtext.y = console_input.y + console_input.height / 2 - console_inputtext.height / 2;
                _ng.starling.nativeOverlay.removeChild(t);
                isFocus = false;
            });

            _ng.starling.nativeOverlay.addChild(t);
            _ng.starling.nativeOverlay.stage.focus = t;
            isFocus = true;
        });

        console_inputtext.format.setTo(BitmapFont.MINI, 16, 0x000000, Align.LEFT, Align.TOP);
        console_inputtext.autoSize = TextFieldAutoSize.VERTICAL;
        console_inputtext.width = stage.stageWidth - 30;
        console_inputtext.x = 15;
        console_inputtext.visible = true;
        console_inputtext.touchable = false;

        console.addChild(console_bg);
        console.addChild(console_text);
        console.addChild(console_input);
        console.addChild(console_inputtext);

        addChild(console);

        _ng.starling.nativeOverlay.stage.addEventListener(Event.RESIZE, function(e:Event) {
            console_bg.width = stage.stageWidth;
            console_bg.height = stage.stageHeight;

            console_text.x = 15;
            console_text.y = stage.stageHeight - console_text.height - console_input.height - 15;

            console_input.width = stage.stageWidth;
            console_input.y = stage.stageHeight - console_input.height;

            console_inputtext.width = stage.stageWidth - 30;
            console_inputtext.y = console_input.y + console_input.height / 2 - console_inputtext.height / 2;
        });
    }

}