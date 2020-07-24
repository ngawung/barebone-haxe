package;

import starling.assets.AssetManager;
import ngawung.utils.ViewportMode;
import starling.core.Starling;

class NG {
	public static var DEBUG:Bool = true;

	public static var BASE_WIDTH:Float = 120;
	public static var BASE_HEIGHT:Float = 240;

	public static var viewportMode:String = ViewportMode.LETTERBOX;

	public static var assetsSize:Array<Int> = [1];
	public static var antiAlias:Int = 0;

	public static var starling:Starling;
	public static var assets:AssetManager;

	// shortcut

	public static function getRoot():Game {
		return cast(NG.starling.root, Game);
	}
}