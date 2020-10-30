package ngawung.core;

import openfl.ui.Keyboard;
import ngawung.events.NGEvent;
import starling.events.Event;
import ngawung.input.Input;
import starling.events.EnterFrameEvent;
import ngawung.core.Scene;
import starling.display.Sprite;

class Game extends Sprite {

	private var _ng(get, null):MainEngine;

	public var input(default, null):Input;
	public var scene(default, set):Scene;

	public function new () {
		super();
		
	}

	public function init():Void {
		input = new Input();

		if (_ng.config.debug) stage.addChild(_ng.console);

		stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

		dispatchEvent(new Event(NGEvent.GAME_INIT));
	}

	public function resize():Void {
		if (scene != null) scene.resize();
	}

	public function onEnterFrame(e:EnterFrameEvent):Void {
		if (scene != null) scene.preUpdate(e.passedTime);

		if (_ng.config.debug) {
			if (input.isDown(Keyboard.BACKQUOTE)) _ng.console.consoleToggle();
			if (input.isDown(Keyboard.ENTER) && _ng.console.visible) _ng.console.consoleProcess();
			if (input.isDown(Keyboard.UP) && _ng.console.visible) _ng.console.consoleInputLog("up");
			if (input.isDown(Keyboard.DOWN) && _ng.console.visible) _ng.console.consoleInputLog("down");
		}

		// input harus paling terakir
		input.update(e.passedTime);
	}

	private function set_scene(scene:Scene):Scene {
		if (this.scene != null) this.scene.destroy(true);

		this.scene = scene;
		addChild(this.scene);
		this.scene.PreInit();

		return this.scene;
	}

	// GET && SET

	private function get__ng():MainEngine { return MainEngine.instance; }
	
}