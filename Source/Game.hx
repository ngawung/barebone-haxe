package;

import ngawung.input.Input;
import scene.Scene1;
import starling.events.EnterFrameEvent;
import ngawung.NGScene;
import starling.events.Event;
import starling.display.Sprite;

class Game extends Sprite {

	public var input:Input;
	private var _curentScene:NGScene;

	public function new () {
		super();
		
	}

	public function init():Void {
		input = new Input();

		stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

		scene(new Scene1());
	}

	public function onEnterFrame(e:EnterFrameEvent):Void {
		if (_curentScene != null) _curentScene.preUpdate(e.passedTime);
		
		input.update(e.passedTime);
	}

	public function scene(scene:NGScene):Void {
		if (_curentScene != null) _curentScene.destroy(true);

		_curentScene = scene;
		addChild(_curentScene);
		_curentScene.init();
	}
	
}