package;

import openfl.utils.Assets;
import scene.Scene1;
import openfl.display.Sprite;
import openfl.events.Event;
import ngawung.events.NGEvent;
import ngawung.utils.ViewportMode;
import ngawung.core.MainEngine;

class Main extends Sprite {
	private var _ng:MainEngine;

	public function new () {
		super();
		_ng = MainEngine.instance;

		// setup engine config
		_ng.debug = true;
		_ng.antiAlias = 1;
		_ng.viewportMode = ViewportMode.FULLSCREEN;

		// start engine
		_ng.setupStarling(false, stage, ViewportMode.FULLSCREEN);
		_ng.addEventListener(NGEvent.STARLING_READY, onStarlingReady);
		_ng.addEventListener(NGEvent.GAME_INIT, onGameInit);
	}
	
	private function onStarlingReady(e:Event):Void {
		_ng.removeEventListener(NGEvent.STARLING_READY, onStarlingReady);

		trace("starling Ready!!!");
	}

	private function onGameInit(e:Event):Void {
		_ng.removeEventListener(NGEvent.GAME_INIT, onGameInit);

		trace("game init!!!");

		_ng.assetManager.enqueue([
			Assets.getPath("assets/openfl.png"),
			Assets.getPath("assets/logonav.png")
		]);

		_ng.assetManager.loadQueue(function():Void {
			_ng.gameRoot.scene = new Scene1();
		});
	}
	
}