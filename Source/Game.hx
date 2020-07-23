package;

import starling.events.EnterFrameEvent;
import ngawung.NGScene;
import starling.events.Event;
import starling.display.Sprite;

class Game extends Sprite {

	private var scene(default, set):NGScene;

	public function new () {
		super ();
		
	}

	public function init():Void {
		// input init here

		stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
	}

	public function onEnterFrame(e:EnterFrameEvent):Void {
		if (this.scene != null) this.scene.preUpdate(e.passedTime);
		// input
	}

	public function set_scene(scene:NGScene):NGScene {
		if (this.scene != null) this.scene.destroy(true);

		this.scene = scene;
		addChild(this.scene);
		this.scene.init();

		return this.scene;
	}
	
}