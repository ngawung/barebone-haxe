package ngawung.utils;

import openfl.geom.Rectangle;

class Config {

    /**
     * Toggle debug mode. default false
     */
    public var debug:Bool;

    /**
     * Antialias level. default 1
     */
    public var antialias:Int;

    /**
     * setup viewport mode. default FULLSCREEN
     */
    public var viewportMode:ViewportMode;

    /**
     * Base screen size. default 800x480
     */
    public var baseScreen:Rectangle;

    /**
     * this automatically constructed by the engine
     */
    public function new() {
        this.debug = false;
        this.antialias = 1;
        this.viewportMode = ViewportMode.FULLSCREEN;
        this.baseScreen = new Rectangle();
    }

}