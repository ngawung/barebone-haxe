package ngawung.display.tilemap;

import ngawung.core.Scene;
import openfl.errors.Error;
import openfl.geom.Point;
import starling.utils.MathUtil;
import ngawung.display.Atom;
import starling.display.Sprite;
import starling.events.Event;

class TileLayer extends Sprite implements Atom {
    public var TileConfig(default, null):TileConfig;
    public var TileMap(default, null):TileMap;

    private var SceneRoot:Scene;

    private var VisibleTileWidth:Int;
    private var VisibleTileHeight:Int;
    private var VisibleTileHeight_clamp:Int;
    private var VisibleTileWidth_clamp:Int;
    private var VisibleGhostTile:Int = 1;

    private var cameraPos:Point = new Point();

    private var TileList:Array<TileAtom> = [];
    
    public function new(TileMap:TileMap, TileConfig:TileConfig) {
        super();
        this.TileMap = TileMap;
        this.TileConfig = TileConfig;

        if (TileMap.MapArray.length == 0 || TileMap.MapArray[0].length == 0)
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
        if (cameraPos.x == Math.floor(SceneRoot.camera.x / TileMap.TileSize) && cameraPos.y == Math.floor(SceneRoot.camera.y / TileMap.TileSize)) return;

        // update cameraPos
        cameraPos.setTo(
            Math.floor(SceneRoot.camera.x / TileMap.TileSize),
            Math.floor(SceneRoot.camera.y / TileMap.TileSize)
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
            var newTileId:String = TileMap.getMapFromPos(tile_x, tile_y);
            TileOldPos[i].setTo(TileNewPos[i], newTileId, TileConfig.getTileConfig(newTileId).TextureName);
            TileOldPos[i].x = tile_x * TileMap.TileSize;
            TileOldPos[i].y = tile_y * TileMap.TileSize;
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
        VisibleTileWidth = Std.int(Math.floor(stage.stageWidth / TileMap.TileSize));
        VisibleTileHeight = Std.int(Math.floor(stage.stageHeight / TileMap.TileSize));
        
        // calculate new VisisbleTile
        VisibleTileHeight_clamp = Std.int(MathUtil.clamp((VisibleTileHeight + VisibleGhostTile), 0, TileMap.MapArray.length));
        VisibleTileWidth_clamp = Std.int(MathUtil.clamp((VisibleTileWidth + VisibleGhostTile), 0, TileMap.MapArray[0].length));
    }

    private function initTile():Void {
        // calculate new VisibleTile
        calculateVisibleTile();

        // update cameraPos
        cameraPos.setTo(
            Math.floor(SceneRoot.camera.x / TileMap.TileSize),
            Math.floor(SceneRoot.camera.y / TileMap.TileSize)
        );

        // add tile to TileList
        for (y in 0...VisibleTileHeight_clamp) {
            for (x in 0...VisibleTileWidth_clamp) {
                var tileId:String = TileMap.getMapFromPos(Std.int(cameraPos.x + x), Std.int(cameraPos.y + y));
                var tile:TileAtom = new TileAtom('${cameraPos.x + x}:${cameraPos.y + y}', tileId, TileConfig.getTileConfig(tileId).TextureName);

                tile.x = (cameraPos.x + x) * TileMap.TileSize;
                tile.y = (cameraPos.y + y) * TileMap.TileSize;
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
        SceneRoot.camera.x = MathUtil.clamp(SceneRoot.camera.x, 0, (TileMap.MapArray[0].length - VisibleTileWidth) * TileMap.TileSize);
        SceneRoot.camera.y = MathUtil.clamp(SceneRoot.camera.y, 0, (TileMap.MapArray.length - VisibleTileHeight) * TileMap.TileSize);
    }
}