package ngawung.core;

import starling.utils.Max;
import ngawung.utils.Config;
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

	public var config:Config;
	public var starling(default, null):Starling;
	public var gameRoot(get, default):Game;
	public var assetManager(default, null):AssetManager;
	
	private var _isMobile:Bool;
	private var _stage:Stage;
	
	private var _viewport:Rectangle = new Rectangle();
	private var _baseRectangle:Rectangle = new Rectangle();
	private var _screenRectangle:Rectangle = new Rectangle();
	
	private function new() {
		super();
		config = new Config();
	}

	/**
	 * Run this to start starling
	 */
	public function setupStarling(isMobile:Bool = false, stage:Stage):Void {
		_isMobile = isMobile;
		_stage = stage;
		
		starling = new Starling(Game, stage, null, null, Context3DRenderMode.AUTO);
		
		if (config.debug) {
			starling.simulateMultitouch = true;
		}
		starling.antiAliasing = config.antialias;
		starling.skipUnchangedFrames = true;
		starling.supportBrowserZoom = true;
		starling.supportHighResolutions = true;
		
		_stage.addEventListener(openfl.events.Event.RESIZE, screenSetup, false, Max.INT_MAX_VALUE, true);
		
		starling.addEventListener(Event.ROOT_CREATED, onRootReady);
		starling.start();
	}

	private function onRootReady():Void {
		// screenSetup();
		setStats();
		handleStarlingReady();
	}

	private function setStats():Void {
		if (config.debug) starling.showStatsAt(Align.RIGHT);
	}

	private function screenSetup(e:openfl.events.Event):Void {
		// set viewport ke ukuran stage/layar
		if (_isMobile) _viewport.setTo(0, 0, _stage.fullScreenWidth, _stage.fullScreenHeight);
		else _viewport.setTo(0, 0, _stage.stageWidth, _stage.stageHeight);

		// setup basic rectangle
		// set basescreen fullscreen kalo blm diset
		if (config.baseScreen.width <= 0) _baseRectangle.width = _viewport.width;
		else _baseRectangle.width = config.baseScreen.width;
		
		if (config.baseScreen.height <= 0) _baseRectangle.height = _viewport.height;
		else _baseRectangle.height = config.baseScreen.height;
		
		_screenRectangle.copyFrom(_viewport);
		trace("base rect", _baseRectangle);
		trace("screen rect", _screenRectangle);

		// calculate new viewport
		RectangleUtil.fit(_baseRectangle, _screenRectangle, ScaleMode.SHOW_ALL, false, _viewport);
		
		switch(config.viewportMode) {
			case ViewportMode.LETTERBOX:
				// set starling stage to base size
				starling.stage.stageWidth = Std.int(_baseRectangle.width);
				starling.stage.stageHeight = Std.int(_baseRectangle.height);

				starling.viewPort.copyFrom(_viewport);
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
		assetManager.verbose = config.debug;
		
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