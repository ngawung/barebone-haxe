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
		_ng.config.debug = true;
		_ng.config.antialias = 1;
		_ng.config.viewportMode = ViewportMode.FULLSCREEN;

		// setup event
		_ng.addEventListener(NGEvent.GAME_INIT, onGameInit);
		
		// start engine
		_ng.setupStarling(false, stage);
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