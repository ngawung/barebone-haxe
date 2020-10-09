package;

import starling.assets.AssetManager;
import ngawung.utils.ViewportMode;
import starling.core.Starling;

class NG {
	public static var DEBUG:Bool = true;

	public static var BASE_WIDTH:Float = 600;
	public static var BASE_HEIGHT:Float = 300;

	public static var viewportMode:String = ViewportMode.FULLSCREEN;

	public static var assetsSize:Array<Int> = [1];
	public static var antiAlias:Int = 0;

	public static var starling:Starling;
	public static var assets:AssetManager;

	// shortcut, note make sure starling already init
	// before using this sortcut

	public static var game:Game;
}