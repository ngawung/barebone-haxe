package ngawung.core;

import openfl.display.Stage;
import openfl.events.EventDispatcher;
import ngawung.events.NGEvent;
import openfl.display3D.Context3DRenderMode;
import starling.assets.AssetManager;
import ngawung.utils.ViewportMode;
import starling.utils.ScaleMode;
import starling.utils.RectangleUtil;
import starling.utils.Align;
import starling.events.Event;
import openfl.geom.Rectangle;
import starling.core.Starling;

class MainEngine extends EventDispatcher {

	public static final instance:MainEngine = new MainEngine();

	private var _viewport:Rectangle = new Rectangle();
	private var _baseRectangle:Rectangle = new Rectangle();
	private var _screenRectangle:Rectangle = new Rectangle();

	public var starling(default, null):Starling;
	public var gameRoot(get, default):Game;
	public var assetManager(default, null):AssetManager;

	public var antiAlias:Int = 1;
	public var debug:Bool = false;
	public var viewportMode:ViewportMode;
	
	private function new() {
		super();
		
	}

	/**
	 * Run this to start starling
	 */
	public function setupStarling(isMobile:Bool = false, stage:Stage, mode:ViewportMode):Void {
		viewportMode = mode;
		
		if (isMobile) _viewport.setTo(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
		else _viewport.setTo(0, 0, stage.stageWidth, stage.stageHeight);
		
		starling = new Starling(Game, stage, _viewport, null, Context3DRenderMode.AUTO);

		if (debug) {
			starling.simulateMultitouch = true;
		}
		starling.antiAliasing = antiAlias;
		starling.skipUnchangedFrames = true;

		starling.addEventListener(Event.ROOT_CREATED, onRootReady);
		starling.start();
	}

	private function onRootReady():Void {
		screenSetup();
		setStats();
		handleStarlingReady();
	}

	private function setStats():Void {
		if (debug) starling.showStatsAt(Align.RIGHT);
	}

	private function screenSetup():Void {
		// setup basic rectangle
		// set base to screen size if not defined || Note: viewport dsini blm di rubah == screensize
		if (_baseRectangle.width <= 0) _baseRectangle.width = _viewport.width;
		if (_baseRectangle.height <= 0) _baseRectangle.height = _viewport.height;
		
		_screenRectangle.setTo(0, 0, _viewport.width, _viewport.height);
		trace(_baseRectangle);
		trace(_screenRectangle);

		// calculate new viewport
		RectangleUtil.fit(_baseRectangle, _screenRectangle, ScaleMode.SHOW_ALL, false, _viewport);
		
		switch(viewportMode) {
			case ViewportMode.LETTERBOX:
				// set starling stage to base size
				starling.stage.stageWidth = Std.int(_baseRectangle.width);
				starling.stage.stageHeight = Std.int(_baseRectangle.height);

			case ViewportMode.FULLSCREEN:
				// get ratio size
				var baseRatioWidth:Float = _viewport.width / _baseRectangle.width;
				var baseRatioHeight:Float = _viewport.height / _baseRectangle.height;
				
				// change viewport to screen size
				starling.viewPort.copyFrom(_screenRectangle);
				
				// set starling stage based on ratio
				starling.stage.stageWidth = Std.int(_screenRectangle.width / baseRatioWidth);
				starling.stage.stageHeight = Std.int(_screenRectangle.height / baseRatioHeight);
		}
	}
	
	private function handleStarlingReady():Void {
		starling.removeEventListener(Event.ROOT_CREATED, onRootReady);
		dispatchEvent(new openfl.events.Event(NGEvent.STARLING_READY));

		// this may change later
		assetManager = new AssetManager();
		assetManager.verbose = debug;
		
		// setup event for game init
		gameRoot.addEventListener(NGEvent.GAME_INIT, function():Void {
			gameRoot.removeEventListeners(NGEvent.GAME_INIT);
			dispatchEvent(new openfl.events.Event(NGEvent.GAME_INIT));
		});
		
		gameRoot.init();
	}

	// GET && SET

	private function get_starling():Starling { return starling; }
	private function get_gameRoot():Game { return cast(starling.root, Game); }

}