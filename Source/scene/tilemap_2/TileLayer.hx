package scene.tilemap_2;

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
    private var VisibleGhostTile:Int = 0;

    private var pos_tile1:Point = new Point();
    private var pos_tile2:Point = new Point();
    private var pos_cam1:Point = new Point();
    private var pos_cam2:Point = new Point();

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

    public function update(dt:Float):Void {

        // check if tile is inside camera
        // for (i in 0...TileList.length) {
        //     // TileList[i].isInBound();
        // }

        // update new tile if any
        //
        //
    }

    public function destroy(removeFromParent:Bool = false):Void {
        // destroy every tile in TileList
        for (i in 0...TileList.length) TileList[i].destroy(removeFromParent);

        // some cleanup here
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

        // get current camera tile position
        var cameraPosX:Int = Std.int(Math.floor(SceneRoot.camera.x / config.tile_size));
        var cameraPosY:Int = Std.int(Math.floor(SceneRoot.camera.y / config.tile_size));

        // add tile to TileList
        for (y in 0...VisibleTileHeight_clamp) {
            for (x in 0...VisibleTileWidth_clamp) {
                var tile:TileAtom = new TileAtom('${cameraPosX + x}:${cameraPosY + y}', config.getMap(cameraPosY + y, cameraPosX + x), config.getTextureNameMap(cameraPosX + x, cameraPosY + y));
                tile.x = (cameraPosX + x) * config.tile_size;
                tile.y = (cameraPosY + y) * config.tile_size;
                TileList.push(tile);
                addChild(tile);
            }
        }
    }

    // #######

    public function resize():Void {
        // // calculate new VisibleTile
        // calculateVisibleTile();        

        // // update TileList size

        // if (TileList.length < VisibleTileHeight_clamp) {
        //     for (y in 0...(VisibleTileHeight_clamp - TileList.length)) {
        //         var x_array:Array<TileAtom> = [];
        //         for (x in 0...TileList[0].length) {
        //             var tile:TileAtom = new TileAtom();
        //             x_array.push(tile);
        //             addChild(tile);
        //         }
        //         TileList.push(x_array);
        //     }
        // }

        // if (TileList.length > VisibleTileHeight_clamp) {
        //     for (y in 0...(TileList.length - VisibleTileHeight_clamp)) {
        //         var x_array:Array<TileAtom> = TileList.pop();
        //         for (x in 0...x_array.length) {
        //             x_array[x].destroy(true);
        //         }
        //     }
        // }

        // if (TileList[0].length < VisibleTileWidth_clamp) {
        //     for (y in 0...TileList.length) {
        //         for (x in 0...(VisibleTileWidth_clamp - TileList[0].length)) {
        //             var tile:TileAtom = new TileAtom();
        //             TileList[y].push(tile);
        //             addChild(tile);
        //         }
        //     }
        // }

        // if (TileList[0].length > VisibleTileWidth_clamp) {
        //     for (y in 0...TileList.length) {
        //         for (x in 0...(TileList[0].length - VisibleTileWidth_clamp)) {
        //             TileList[y].pop().destroy(true);
        //         }
        //     }
        // }

        // // trace(TileList[0][0].x, TileList[0][0].y);

        // pos_tile1.setTo(
        //     Math.floor(TileList[0][0].x / config.tile_size),
        //     Math.floor(TileList[0][0].y / config.tile_size)
        // );

        // pos_tile2.setTo(
        //     Math.floor(TileList[TileList.length - 1][TileList[0].length - 1].x / config.tile_size),
        //     Math.floor(TileList[TileList.length - 1][TileList[0].length - 1].y / config.tile_size)
        // );

        // updatePos();
        // // clampCamera();
    }

    public function updatePos() {
        // // does tile pos on the right position
        // pos_cam1.setTo(
        //     Math.floor(SceneRoot.camera.x / config.tile_size),
        //     Math.floor(SceneRoot.camera.y / config.tile_size)
        // );

        // pos_cam2.setTo(
        //     Math.floor(SceneRoot.camera.x + stage.stageWidth / config.tile_size),
        //     Math.floor(SceneRoot.camera.y + stage.stageHeight / config.tile_size)
        // );

        // if (pos_tile1.x != pos_cam1.x || pos_tile1.y != pos_cam1.y) {
        //     trace("update post");

        //     for (y in 0...TileList.length) {
        //         for (x in 0...TileList[0].length) {
        //             var conf:TileConfig = config.tile_config.filter(function(data) { return data.tileId == config.MapData[Std.int(y + pos_cam1.y)].charAt(Std.int(x + pos_cam1.x)); })[0];
        //             TileList[y][x].setTo(conf);
        //             TileList[y][x].x = (x + pos_cam1.x) * config.tile_size;
        //             TileList[y][x].y = (y + pos_cam1.y) * config.tile_size;
        //         }
        //     }

        //     pos_tile1.setTo(pos_cam1.x, pos_cam1.y);
        // }

    }

    public function clampCamera() {
        SceneRoot.camera.x = MathUtil.clamp(SceneRoot.camera.x, 0, (config.MapData[0].length - VisibleTileWidth) * config.tile_size);
        SceneRoot.camera.y = MathUtil.clamp(SceneRoot.camera.y, 0, (config.MapData.length - VisibleTileHeight) * config.tile_size);
        
    }
}