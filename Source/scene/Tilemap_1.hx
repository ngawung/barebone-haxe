package scene;

import starling.display.Quad;
import openfl.ui.Keyboard;
import starling.display.Image;
import ngawung.core.Scene;

class Tilemap_1 extends Scene {

    private var TileSize:Int = 64;

    private var VisibleTileWidth:Int = 12;
    private var VisibleTileHeight:Int = 7;

    private var MapsData:Array<String> = [];
    private var TileList:Array<Image> = [];

    private var cameraSpeed:Int = 5;

    public function new() {
        super();

        MapsData.push("......................................");
        MapsData.push("...##........................####.....");
        MapsData.push("###.........#####.........#####.......");
        MapsData.push("...........#####......................");
        MapsData.push("###################.######....#######.");
        MapsData.push(".........#..........#.......####......");
        MapsData.push(".........#.##########....####.........");
        MapsData.push(".........#..............####..........");
        MapsData.push(".........################.............");
        MapsData.push("......................................");

        var TextureName:String = "";
        for(y in 0...VisibleTileHeight) {
            for(x in 0...VisibleTileWidth) {
                switch(MapsData[y].charAt(x)) {
                    case ".": TextureName = "tile2";
                    case "#": TextureName = "tile1";
                }

                var img:Image = new Image(_ng.assetManager.getTexture(TextureName));
                img.x = x * TileSize;
                img.y = y * TileSize;
                TileList.push(img);
                addChild(img);
            }
        }
    }
    
    override public function init():Void {
        camera.enable = true;

        // for (x in 0...VisibleTileWidth) {
        //     var q:Quad = new Quad(10, 10, 0xFF00D2);
        //     q.x = TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].x;
        //     q.y = TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].y;
        //     addChild(q);
        // }

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

        // loop tile

        // check left side tile
        if (TileList[0].x + TileSize < camera.x) {
            for (y in 0...VisibleTileHeight) {
                // move tile
                TileList[y * VisibleTileWidth].x = TileList[y * VisibleTileWidth + VisibleTileWidth - 1].x + TileSize;

                // move tile in TileList
                TileList.insert(y * VisibleTileWidth + VisibleTileWidth - 1, TileList.splice(y * VisibleTileWidth, 1)[0]);
            }
        }

        // check right side tile
        if (TileList[VisibleTileWidth - 1].x > camera.x + stage.stageWidth) {
            for (y in 0...VisibleTileHeight) {
                // move tile
                TileList[y * VisibleTileWidth + VisibleTileWidth - 1].x = TileList[y * VisibleTileWidth].x - TileSize;

                // move tile in TileList
                TileList.insert(y * VisibleTileWidth, TileList.splice(y * VisibleTileWidth + VisibleTileWidth - 1, 1)[0]);
            }
        }

        // check top side tile
        if (TileList[0].y + TileSize < camera.y) {
            for (x in 0...VisibleTileWidth) {
                // move tile
                TileList[x].y = TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].y + TileSize;
            }
            // move tile in TileList
            TileList = TileList.concat(TileList.splice(0, VisibleTileWidth));
        }

        // check bottom side tile
        if (TileList[(VisibleTileHeight - 1) * VisibleTileWidth].y > camera.y + stage.stageHeight) {
            for (x in 0...VisibleTileWidth) {
                // move tile
                TileList[(VisibleTileHeight - 1) * VisibleTileWidth + x].y = TileList[x].y - TileSize;
            }
            // move tile in TileList
            TileList = TileList.splice((VisibleTileHeight - 1) * VisibleTileWidth , VisibleTileWidth).concat(TileList);
        }

    }

}