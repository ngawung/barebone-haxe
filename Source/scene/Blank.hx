package scene;

import starling.utils.MathUtil;
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
    private var console_inputLog:Array<String> = [];
    private var console_inputPos:Int;

    private var isFocus:Bool = false;

    public function new() {
        super();

    }

    override function init() {
        init_console();

        var oldTrace = Log.trace;
        Log.trace = function (v:Dynamic, ?info:PosInfos) {
            oldTrace(v, info);

            var text_array = console_text.text.split("\n");
            if (text_array.length > 40) text_array.shift();
            text_array.push(Log.formatOutput(v, info));

            console_text.text = text_array.join("\n");
            console_text.y = stage.stageHeight - console_text.height - console_input.height - 15;
        }

        trace("init");
    }

    override function update(dt:Float) {
        
        if (input.isDown(Keyboard.BACKQUOTE)) consoleToggle();
        if (input.isDown(Keyboard.ENTER) && console.visible) consoleProcess();
        if (input.isDown(Keyboard.UP) && console.visible) consoleInputLog("up");
        if (input.isDown(Keyboard.DOWN) && console.visible) consoleInputLog("down");

    }

    // ####

    private function init_console():Void {
        console_bg.width = stage.stageWidth;
        console_bg.height = stage.stageHeight;

        console_text.format.setTo(BitmapFont.MINI, 16, 0xFFFFFF, Align.LEFT, Align.TOP);
        console_text.autoSize = TextFieldAutoSize.VERTICAL;
        console_text.width = stage.stageWidth - 10;
        console_text.wordWrap = true;
        console_text.x = 5;

        console_input.width = stage.stageWidth;
        console_input.height = 20;
        console_input.y = stage.stageHeight - console_input.height;
        console_input.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
            if (e.getTouch(console_input, TouchPhase.ENDED) == null || isFocus) return;

            consoleFocusIn();
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

            console_text.x = 5;
            console_text.y = stage.stageHeight - console_text.height - console_input.height - 15;
            console_text.width = stage.stageWidth - 10;

            console_input.width = stage.stageWidth;
            console_input.y = stage.stageHeight - console_input.height;

            console_inputtext.width = stage.stageWidth - 30;
            console_inputtext.y = console_input.y + console_input.height / 2 - console_inputtext.height / 2;
        });
    }

    private function consoleFocusIn():Void {
        var t:openfl.text.TextField = new openfl.text.TextField();
        t.type = TextFieldType.INPUT;
        t.width = console_input.width;
        t.height = console_input.height;
        t.multiline = false;
        t.sharpness = 0;
        t.y = console_input.y;
        t.text = console_inputtext.text;
        t.setSelection(t.text.length, t.text.length);
        console_inputtext.visible = false;

        t.addEventListener(FocusEvent.FOCUS_OUT, consoleFocusOut);

        _ng.starling.nativeOverlay.addChild(t);
        _ng.starling.nativeOverlay.stage.focus = t;
        isFocus = true;
    }

    private function consoleFocusOut(e:FocusEvent):Void {
        console_inputtext.visible = true;
        console_inputtext.text = cast(e.currentTarget, openfl.text.TextField).text;
        console_inputtext.y = console_input.y + console_input.height / 2 - console_inputtext.height / 2;
        _ng.starling.nativeOverlay.removeChild(e.target);
        isFocus = false;
    }

    private function consoleToggle():Void {
        if (isFocus) {
            _ng.starling.nativeOverlay.stage.focus = null;
            console_inputtext.text = console_inputtext.text.substr(0, console_inputtext.text.length - 1);
        }
        
        console.visible = !console.visible;
    }

    private function consoleProcess():Void {
        if (!isFocus) return consoleFocusIn();
        
        _ng.starling.nativeOverlay.stage.focus = null;

        if (console_inputLog.length > 20) console_inputLog.shift();
        console_inputLog.push(console_inputtext.text);
        console_inputPos = console_inputLog.length;

        var args:Array<String> = StringTools.trim(console_inputtext.text).split(" ");
        var cmdName:String = args.shift().toLowerCase();
        console_inputtext.text = "";

        switch (cmdName) {
            case "trace": trace(args.join(" "));

            case "driverinfo": trace("Display Driver: " + _ng.starling.context.driverInfo);

            default: trace('Command "${cmdName}" is invalid.');
        }
    }

    private function consoleInputLog(direction:String):Void {
        if (isFocus) _ng.starling.nativeOverlay.stage.focus = null;


        if (direction == "up") console_inputPos--;
        else console_inputPos++;

        console_inputPos = Std.int(MathUtil.clamp(console_inputPos, 0, console_inputLog.length - 1));

        trace(console_inputPos, console_inputLog[console_inputPos]);

        console_inputtext.text = console_inputLog[console_inputPos];

        consoleFocusIn();
    }

}