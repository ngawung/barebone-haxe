package;


import openfl.display.Sprite;
import starling.core.Starling;


class Test extends Sprite {
	
	
	private var starling:Starling;
	
	
	public function new () {
		
		super ();
		
		NG.starling = new Starling (Game, stage);
		NG.starling.showStats = true;
		NG.starling.start ();
		
	}
	
	
}