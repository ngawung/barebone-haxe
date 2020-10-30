package ngawung.utils;

import starling.events.Event;
import starling.utils.MathUtil;
import openfl.events.FocusEvent;
import openfl.text.TextFieldType;
import haxe.Constraints.Function;
import haxe.PosInfos;
import haxe.Log;
import ngawung.core.MainEngine;
import starling.events.TouchPhase;
import starling.events.TouchEvent;
import starling.text.TextFieldAutoSize;
import starling.utils.Align;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.display.Quad;
import starling.display.Sprite;

class Console extends Sprite {
    private var _ng(get, null):MainEngine;

    private var bg:Quad;
    private var input_bg:Quad;

    private var log_text:TextField;
    private var log_array:Array<String> = [];

    private var input_text:TextField;
    private var input_array:Array<String> = [];
    private var input_arrayPos:Int;

    private var isAdded:Bool = false;
    public var isFocus(default, null):Bool = false;

    public var log(default, null):Function;
    
    public function new() {
        super();
        setupConsole();
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        
        trace("Console initialized");
    }

    private function onAdded(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        drawConsole();
        isAdded = true;
        visible = false;
    }

    private function drawConsole():Void {
        bg = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
        bg.alpha = 0.4;

        log_text = new TextField(stage.stageWidth - 10, 0, "");
        log_text.format.setTo(BitmapFont.MINI, 16, 0xFFFFFF, Align.LEFT, Align.TOP);
        log_text.autoSize = TextFieldAutoSize.VERTICAL;
        log_text.wordWrap = true;
        log_text.x = 5;
        log_text.touchable = false;

        input_bg = new Quad(stage.stageWidth, 20, 0xFFFFFF);
        input_bg.y = stage.stageHeight - input_bg.height;
        input_bg.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
            if (e.getTouch(input_bg, TouchPhase.ENDED) == null || isFocus) return;

            consoleFocusIn();
        });

        input_text = new TextField(0, 0, "");
        input_text.format.setTo(BitmapFont.MINI, 16, 0x000000, Align.LEFT, Align.TOP);
        input_text.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        input_text.x = 15;
        input_text.visible = true;
        input_text.touchable = false;

        addChild(bg);
        addChild(log_text);
        addChild(input_bg);
        addChild(input_text);
    }

    public function resize():Void {
        if (!isAdded) return;

        bg.width = stage.stageWidth;
        bg.height = stage.stageHeight;

        log_text.x = 5;
        log_text.y = stage.stageHeight - log_text.height - input_bg.height - 15;
        log_text.width = stage.stageWidth - 10;

        input_bg.width = stage.stageWidth;
        input_bg.y = stage.stageHeight - input_bg.height;

        input_text.width = stage.stageWidth - 30;
        input_text.y = input_bg.y + input_bg.height / 2 - input_text.height / 2;
    }

    private function setupConsole():Void {
        log = Log.trace;
        
        Log.trace = function (v:Dynamic, ?info:PosInfos) {
            log(v, info);

            if (log_array.length >= 40) log_array.shift();
            log_array.push(Log.formatOutput(v, info));
            
            if (isAdded) {
                log_text.text = log_array.join("\n");
                log_text.y = stage.stageHeight - log_text.height - input_bg.height - 15;
            }
        }
    }

    private function consoleFocusIn():Void {
        var t:openfl.text.TextField = new openfl.text.TextField();
        t.type = TextFieldType.INPUT;
        t.width = input_bg.width;
        t.height = input_bg.height;
        t.multiline = false;
        t.sharpness = 0;
        t.y = input_bg.y;
        t.text = input_text.text;
        t.setSelection(t.text.length, t.text.length);
        input_text.visible = false;

        t.addEventListener(FocusEvent.FOCUS_OUT, consoleFocusOut);

        _ng.starling.nativeOverlay.addChild(t);
        _ng.starling.nativeOverlay.stage.focus = t;
        isFocus = true;
    }

    private function consoleFocusOut(e:FocusEvent):Void {
        input_text.visible = true;
        input_text.text = cast(e.currentTarget, openfl.text.TextField).text;
        input_text.y = input_bg.y + input_bg.height / 2 - input_text.height / 2;
        _ng.starling.nativeOverlay.removeChild(e.target);
        isFocus = false;
    }

    public function consoleToggle():Void {
        if (isFocus) {
            _ng.starling.nativeOverlay.stage.focus = null;
            input_text.text = input_text.text.substr(0, input_text.text.length - 1);
        }
        
        visible = !visible;
    }

    public function consoleProcess():Void {
        if (!isFocus) return consoleFocusIn();
        
        _ng.starling.nativeOverlay.stage.focus = null;

        if (input_array.length > 20) input_array.shift();
        input_array.push(input_text.text);
        input_arrayPos = input_array.length;

        var args:Array<String> = StringTools.trim(input_text.text).split(" ");
        var cmdName:String = args.shift().toLowerCase();
        input_text.text = "";

        switch (cmdName) {
            case "trace": trace(args.join(" "));

            case "driverinfo": trace("Display Driver: " + _ng.starling.context.driverInfo);

            default: trace('Command "${cmdName}" is invalid.');
        }
    }

    public function consoleInputLog(direction:String):Void {
        if (isFocus) _ng.starling.nativeOverlay.stage.focus = null;


        if (direction == "up") input_arrayPos--;
        else input_arrayPos++;

        input_arrayPos = Std.int(MathUtil.clamp(input_arrayPos, 0, input_array.length - 1));

        trace(input_arrayPos, input_array[input_arrayPos]);

        input_text.text = input_array[input_arrayPos];

        consoleFocusIn();
    }


    // GET && SET

    private function get__ng():MainEngine { return MainEngine.instance; }
}