package ngawung.core;

import ngawung.events.NGEvent;
import starling.events.Event;
import ngawung.input.Input;
import starling.events.EnterFrameEvent;
import ngawung.core.Scene;
import starling.display.Sprite;

class Game extends Sprite {

	public var input(default, null):Input;
	public var scene(default, set):Scene;

	public function new () {
		super();
		
	}

	public function init():Void {
		input = new Input();

		stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

		dispatchEvent(new Event(NGEvent.GAME_INIT));
	}

	public function onEnterFrame(e:EnterFrameEvent):Void {
		if (scene != null) scene.preUpdate(e.passedTime);
		
		input.update(e.passedTime);
	}

	private function set_scene(scene:Scene):Scene {
		if (this.scene != null) this.scene.destroy(true);

		this.scene = scene;
		addChild(this.scene);
		this.scene.PreInit();

		return this.scene;
	}
	
}