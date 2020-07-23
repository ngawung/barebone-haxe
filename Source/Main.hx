package;

import lime.tools.AssetType;
import openfl.display.StageScaleMode;
import lime.utils.Assets;
import starling.assets.AssetManager;
import ngawung.utils.ViewportMode;
import starling.utils.ScaleMode;
import starling.utils.RectangleUtil;
import starling.utils.Align;
import openfl.system.Capabilities;
import starling.events.Event;
import openfl.geom.Rectangle;
import starling.core.Starling;
import openfl.display.Sprite;


class Main extends Sprite {
	
	private var _viewport:Rectangle = new Rectangle();
	private var _baseRectangle:Rectangle = new Rectangle();
	private var _screenRectangle:Rectangle = new Rectangle();
	
	public function new() {
		super();
		if (stage != null) setupStarling(true);
		else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Dynamic):Void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		setupStarling(true);
	}

	public function setupStarling(isMobile:Bool = false):Void {
		if (isMobile) _viewport.setTo(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
		else _viewport.setTo(0, 0, stage.stageWidth, stage.stageHeight);
		
		NG.starling = new Starling(Game, stage, _viewport);
		NG.starling.antiAliasing = NG.antiAlias;
		NG.starling.skipUnchangedFrames = true;
		NG.starling.simulateMultitouch = true;
		NG.starling.addEventListener(Event.ROOT_CREATED, function():Void {
			screenSetup();
			setStats();
			loadAssets();
		});

		NG.starling.start();
	}

	public function setStats() {
		if (NG.DEBUG) NG.starling.showStatsAt(Align.RIGHT);
	}

	public function screenSetup() {
		// set base to screen size if not defined || Note: viewport dsini blm di rubah == screensize
		if (NG.BASE_WIDTH < 0) NG.BASE_WIDTH = _viewport.width;
		if (NG.BASE_HEIGHT < 0) NG.BASE_HEIGHT = _viewport.height;
		
		// setup basic rectangle
		_baseRectangle.setTo(0, 0, NG.BASE_WIDTH, NG.BASE_HEIGHT);
		_screenRectangle.setTo(0, 0, _viewport.width, _viewport.height);
		
		// setup new viewport
		RectangleUtil.fit(_baseRectangle, _screenRectangle, ScaleMode.SHOW_ALL, false, _viewport);
		
		switch(NG.viewportMode) {
			case ViewportMode.LETTERBOX:
				// set starling stage to base size
				NG.starling.stage.stageWidth = Std.int(_baseRectangle.width);
				NG.starling.stage.stageHeight = Std.int(_baseRectangle.height);
			
			case ViewportMode.FULLSCREEN:
				// get ratio size
				var baseRatioWidth:Float = _viewport.width / NG.BASE_WIDTH;
				var baseRatioHeight:Float = _viewport.height / NG.BASE_HEIGHT;
				
				// change viewport to screen size
				NG.starling.viewPort.copyFrom(_screenRectangle);
				
				// set starling stage based on ratio
				NG.starling.stage.stageWidth = Std.int(_screenRectangle.width / baseRatioWidth);
				NG.starling.stage.stageHeight = Std.int(_screenRectangle.height / baseRatioHeight);
		}
	}

	public function loadAssets():Void {
		NG.starling.removeEventListener(Event.ROOT_CREATED, loadAssets);

		NG.assets = new AssetManager();

		NG.assets.verbose = NG.DEBUG;
		NG.assets.enqueue([
			Assets.getPath("assets/openfl.png"),
			Assets.getPath("assets/logonav.png")
			
		]);

		NG.assets.loadQueue(handleStarlingReady);
	}
	
	public function handleStarlingReady() {
		var root:Game = cast(NG.starling.root, Game);
		root.init();

	}
	
}