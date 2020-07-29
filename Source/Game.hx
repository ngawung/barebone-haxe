package;

import ngawung.input.Input;
import scene.Scene1;
import starling.events.EnterFrameEvent;
import ngawung.NGScene;
import starling.events.Event;
import starling.display.Sprite;

class Game extends Sprite {

	public var input(default, null):Input;
	public var scene(default, set):NGScene;

	public function new () {
		super();
		
	}

	public function init():Void {
		input = new Input();

		stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

		scene = new Scene1();
	}

	public function onEnterFrame(e:EnterFrameEvent):Void {
		if (scene != null) scene.preUpdate(e.passedTime);
		
		input.update(e.passedTime);
	}

	private function set_scene(scene:NGScene):NGScene {
		if (this.scene != null) this.scene.destroy(true);

		this.scene = scene;
		addChild(this.scene);
		this.scene.init();

		return this.scene;
	}
	
}