package scene.tilemap_2;

import starling.display.Quad;
import ngawung.core.Scene;
import openfl.errors.Error;
import openfl.geom.Point;
import starling.utils.MathUtil;
import ngawung.display.Atom;
import starling.display.Sprite;
import starling.events.Event;

class TileLayer extends Sprite implements Atom {
    public var config(default, null):MapConfig;

    private var SceneRoot:Scene;

    private var VisibleTileWidth:Int;
    private var VisibleTileHeight:Int;
    private var VisibleTileHeight_clamp:Int;
    private var VisibleTileWidth_clamp:Int;
    private var VisibleGhostTile:Int = 1;

    private var cameraPos:Point = new Point();

    private var TileList:Array<TileAtom> = [];
    
    public function new(config:MapConfig) {
        super();
        this.config = config;

        if (config.MapData.length == 0 || config.MapData[0].length == 0)
            throw new Error("MapData canneot be empty");

        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        SceneRoot = cast(parent, Scene);
        
        initTile();
    }

    private var test:Bool = false;

    public function update(dt:Float):Void {
        // return if cameraPos didnt changed
        if (cameraPos.x == Math.floor(SceneRoot.camera.x / config.tile_size) && cameraPos.y == Math.floor(SceneRoot.camera.y / config.tile_size)) return;

        // update cameraPos
        cameraPos.setTo(
            Math.floor(SceneRoot.camera.x / config.tile_size),
            Math.floor(SceneRoot.camera.y / config.tile_size)
        );
        
        // // add tile that arent inside camera to TileListRemove
        // for (i in 0...TileList.length) {
        //     var result:Bool = TileList[i].isInBound(SceneRoot.camera.x, SceneRoot.camera.y, stage.stageWidth, stage.stageHeight);
        //     if (!result) TileListRemove.push(TileList[i].tile_pos);
        // }

        // find tile that need to be updated
        var TileTempPos:Array<String> = [];
        var TileNewPos:Array<String> = [];

        var TileOldPos:Array<TileAtom> = [];
        
        // get all tile pos
        for (y in 0...VisibleTileHeight_clamp) {
            for (x in 0...VisibleTileWidth_clamp) {
                TileTempPos.push('${cameraPos.x + x}:${cameraPos.y + y}');
            }
        }

        // get tile old pos
        for (i in 0...TileList.length) {
            if (TileTempPos.indexOf(TileList[i].tile_pos) == -1) {
                TileOldPos.push(TileList[i]);
            }
        }

        // get tile new pos
        for (i in 0...TileTempPos.length) {
            var filter = TileList.filter(function(t:TileAtom):Bool {
                return (TileTempPos[i] == t.tile_pos);
            });

            if (filter.length == 0) TileNewPos.push(TileTempPos[i]);
        }

        // update old pos to new pos
        for (i in 0...TileOldPos.length) {
            var tile_x:Int = Std.parseInt(TileNewPos[i].split(":")[0]);
            var tile_y:Int = Std.parseInt(TileNewPos[i].split(":")[1]);

            TileOldPos[i].setTo(TileNewPos[i], config.getMap(tile_x, tile_y), config.getTextureNameMap(tile_x, tile_y));
            TileOldPos[i].x = tile_x * config.tile_size;
            TileOldPos[i].y = tile_y * config.tile_size;
        }
    }

    public function destroy(removeFromParent:Bool = false):Void {
        // destroy every tile in TileList
        for (i in 0...TileList.length) TileList[i].destroy(removeFromParent);

        // some cleanup here
    }

    public function resize():Void {

    }

    // #######

    private function calculateVisibleTile() {
        // updateVisibleTile
        VisibleTileWidth = Std.int(Math.floor(stage.stageWidth / config.tile_size));
        VisibleTileHeight = Std.int(Math.floor(stage.stageHeight / config.tile_size));
        
        // calculate new VisisbleTile
        VisibleTileHeight_clamp = Std.int(MathUtil.clamp((VisibleTileHeight + VisibleGhostTile), 0, config.MapData.length));
        VisibleTileWidth_clamp = Std.int(MathUtil.clamp((VisibleTileWidth + VisibleGhostTile), 0, config.MapData[0].length));
    }

    private function initTile():Void {
        // calculate new VisibleTile
        calculateVisibleTile();

        // update cameraPos
        cameraPos.setTo(
            Math.floor(SceneRoot.camera.x / config.tile_size),
            Math.floor(SceneRoot.camera.y / config.tile_size)
        );

        // add tile to TileList
        for (y in 0...VisibleTileHeight_clamp) {
            for (x in 0...VisibleTileWidth_clamp) {
                var tile:TileAtom = new TileAtom(
                    '${cameraPos.x + x}:${cameraPos.y + y}',
                    config.getMap(Std.int(cameraPos.x + x), Std.int(cameraPos.y + y)),
                    config.getTextureNameMap(Std.int(cameraPos.x + x), Std.int(cameraPos.y + y))
                );

                tile.x = (cameraPos.x + x) * config.tile_size;
                tile.y = (cameraPos.y + y) * config.tile_size;
                TileList.push(tile);
                addChild(tile);
            }
        }
    }

    // #######

    /**
     * Clamp camera to the MapData
     */
    public function clampCamera() {
        SceneRoot.camera.x = MathUtil.clamp(SceneRoot.camera.x, 0, (config.MapData[0].length - VisibleTileWidth) * config.tile_size);
        SceneRoot.camera.y = MathUtil.clamp(SceneRoot.camera.y, 0, (config.MapData.length - VisibleTileHeight) * config.tile_size);
    }
}