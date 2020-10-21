package scene;

import openfl.geom.Point;
import lime.math.Rectangle;
import starling.utils.MathUtil;
import starling.textures.Texture;
import starling.display.Quad;
import openfl.ui.Keyboard;
import starling.display.Image;
import ngawung.core.Scene;

class Tilemap_1 extends Scene {

    private var TileSize:Int = 64;

    private var VisibleTileWidth:Int = 12;
    private var VisibleTileHeight:Int = 7;
    private var visibleRegion:Point = new Point();

    private var MapsData:Array<String> = [];
    private var TileList:Array<Array<Image>> = [];

    private var cameraSpeed:Int = 5;

    public function new() {
        super();

        MapsData.push("123456789.........123456789.........123");
        MapsData.push("2..##....123456789.........123456789...");
        MapsData.push("3##.........#####.........#####........");
        MapsData.push("4..........#####.......................");
        MapsData.push("5##################.######....#######..");
        MapsData.push("6........#..........#.......####.......");
        MapsData.push("7........#.##########....####..........");
        MapsData.push("8........#..............####...........");
        MapsData.push("9........################..............");
        MapsData.push(".......................................");

        for(y in 0...VisibleTileHeight) {
            var x_array:Array<Image> = [];
            for(x in 0...VisibleTileWidth) {
                var img:Image = new Image(getTexture(x, y));
                img.x = x * TileSize;
                img.y = y * TileSize;
                x_array.push(img);
                addChild(img);
            }
            TileList.push(x_array);
        }

        visibleRegion.setTo(MapsData[0].length * TileSize, MapsData.length * TileSize);
    }
    
    override public function init():Void {
        camera.enable = true;

        // for (x in 0...VisibleTileWidth) {
        //     var q:Quad = new Quad(10, 10, 0xFF00D2);
        //     q.x = TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].x;
        //     q.y = TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].y;
        //     addChild(q);
        // }

        // line helper
        var q:Quad = new Quad(5, stage.stageWidth, 0xB8246E);
        q.x = VisibleTileWidth * TileSize;
        game.addChild(q);

        var q2:Quad = new Quad(stage.stageWidth, 5, 0xB8246E);
        q2.y = VisibleTileHeight * TileSize;
        game.addChild(q2);

        // array testing
        var a:Array<Int> = [0,1,2,3,4,5,6,7,8,9];
        a.insert(4, 99);
        trace(a.concat(a.splice(0, 5)));
    }

    override public function update(dt:Float):Void {
        // controll camera
        if (input.isHeld(Keyboard.W)) camera.y -= cameraSpeed;
        if (input.isHeld(Keyboard.S)) camera.y += cameraSpeed;
        if (input.isHeld(Keyboard.A)) camera.x -= cameraSpeed;
        if (input.isHeld(Keyboard.D)) camera.x += cameraSpeed;

        camera.x = MathUtil.clamp(camera.x, 0, visibleRegion.x - VisibleTileWidth * TileSize);
        camera.y = MathUtil.clamp(camera.y, 0, visibleRegion.y);

        // loop tile

        // check left side tile
        if (TileList[0][0].x + TileSize <= camera.x) {
            for (y in 0...VisibleTileHeight) {
                // move tile
                TileList[y][0].x = TileList[y][VisibleTileWidth - 1].x + TileSize;
                TileList[y][0].texture = getTexture(Math.floor(camera.x / TileSize) + (VisibleTileWidth - 1), y);

                // move tile in TileList
                TileList[y].push(TileList[y].shift());
            }
        }

        // check right side tile
        if (TileList[0][VisibleTileWidth - 1].x >= camera.x + VisibleTileWidth * TileSize) {
            for (y in 0...VisibleTileHeight) {
                // move tile
                trace("start loop");
                TileList[y][VisibleTileWidth - 1].x = TileList[y][0].x - TileSize;
                TileList[y][VisibleTileWidth - 1].texture = getTexture(Math.floor((camera.x + 2) / TileSize), y);

                // move tile in TileList
                TileList[y].insert(0, TileList[y].pop());
            }
        }

        // // check top side tile
        // if (TileList[0].y + TileSize < camera.y) {
        //     for (x in 0...VisibleTileWidth) {
        //         // move tile
        //         TileList[x].y = TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].y + TileSize;
        //     }
        //     // move tile in TileList
        //     TileList = TileList.concat(TileList.splice(0, VisibleTileWidth));
        // }

        // // check bottom side tile
        // if (TileList[(VisibleTileHeight - 1) * VisibleTileWidth].y > camera.y + stage.stageHeight) {
        //     for (x in 0...VisibleTileWidth) {
        //         // move tile
        //         TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].y = TileList[x].y - TileSize;
        //     }
        //     // move tile in TileList
        //     TileList = TileList.splice((VisibleTileHeight - 1) * VisibleTileWidth , VisibleTileWidth).concat(TileList);
        // }

    }

    private function getTexture(x:Int, y:Int):Texture {
        trace(x, y, MapsData[y].charAt(x));
        switch(MapsData[y].charAt(x)) {
            case ".": return _ng.assetManager.getTexture("tile2");
            case "#": return _ng.assetManager.getTexture("tile1");
            case "1": return _ng.assetManager.getTexture("1");
            case "2": return _ng.assetManager.getTexture("2");
            case "3": return _ng.assetManager.getTexture("3");
            case "4": return _ng.assetManager.getTexture("4");
            case "5": return _ng.assetManager.getTexture("5");
            case "6": return _ng.assetManager.getTexture("6");
            case "7": return _ng.assetManager.getTexture("7");
            case "8": return _ng.assetManager.getTexture("8");
            case "9": return _ng.assetManager.getTexture("9");

            default: return _ng.assetManager.getTexture("tile2");
        }
    }

}