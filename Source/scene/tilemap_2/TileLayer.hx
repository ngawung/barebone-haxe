package scene.tilemap_2;

import ngawung.display.Atom;
import starling.display.Sprite;
import starling.events.Event;

class TileLayer extends Sprite implements Atom {
    public var config(default, null):MapConfig;

    private var VisibleTileWidth:Int;
    private var VisibleTileHeight:Int;
    private var VisibleGhostTile:Int = 0;

    private var TileList:Array<Array<TileAtom>> = [[]];
    
    public function new(config:MapConfig) {
        super();
        this.config = config;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        
        updateTileList();
    }

    public function update(dt:Float):Void {

    }

    public function destroy(removeFromParent:Bool = false):Void {

    }

    // #######

    private function updateTileList():Void {
        // updateVisibleTile
        VisibleTileWidth = Std.int(Math.floor(stage.stageWidth / config.tile_size));
        VisibleTileHeight = Std.int(Math.floor(stage.stageHeight / config.tile_size));
        
        trace("VisibleTile:", VisibleTileWidth, VisibleTileHeight);

        // return if no need change
        if (TileList.length == VisibleTileHeight || TileList[0].length == VisibleTileHeight) return;

        // destroy all TileList
        for(y in 0...TileList.length) {
            for(x in 0...TileList[0].length) {
                TileList[y][x].destroy(true);
            }
        }

        // add tile to TileList
        for(y in 0...VisibleTileHeight + VisibleGhostTile) {
            var x_array:Array<TileAtom> = [];
            for(x in 0...VisibleTileWidth + VisibleGhostTile) {
                var conf:TileConfig = config.tile_config.filter(function(data) { return data.tileId == config.MapData[y].charAt(x); })[0];
                
                var tile:TileAtom = new TileAtom(conf);
                tile.x = x * config.tile_size;
                tile.y = y * config.tile_size;
                x_array.push(tile);
                addChild(tile);
            }
            TileList.push(x_array);
        }
    }
}