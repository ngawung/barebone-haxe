package scene;

import starling.text.TextFieldAutoSize;
import starling.text.BitmapFont;
import starling.text.TextField;
import openfl.geom.Point;
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
    private var VisibleGhostTile:Int = 1;
    private var visibleRegion:Point = new Point();

    private var MapsData:Array<String> = [];
    private var TileList:Array<Array<Image>> = [];

    private var StartPos:Point = new Point(0, 0);
    private var CurrentPos:Point = new Point();
    private var cameraSpeed:Int = 5;

    private var logText:TextField = new TextField(0, 0, "");

    public function new() {
        super();

        MapsData.push("123456789..............................");
        MapsData.push("2..##....123456789.....................");
        MapsData.push("3##.........#####.123456789####........");
        MapsData.push("4..........#####...........123456789...");
        MapsData.push(".1#################.######....######123");
        MapsData.push(".2.......#..........#.......####.......");
        MapsData.push(".3.......#.##########....####..........");
        MapsData.push(".4.......#..............####...........");
        MapsData.push("..1......################..............");
        MapsData.push("..2....................................");
        MapsData.push("..3....................................");
        MapsData.push("..4....................................");
        MapsData.push("...1...................................");
        MapsData.push("...2...................................");
        MapsData.push("...3...................................");
        MapsData.push("...4...................................");
        
        for(y in 0...VisibleTileHeight + VisibleGhostTile) {
            var x_array:Array<Image> = [];
            for(x in 0...VisibleTileWidth + VisibleGhostTile) {
                var img:Image = new Image(getTexture(x, y));
                img.x = x * TileSize;
                img.y = y * TileSize;
                x_array.push(img);
                addChild(img);
            }
            TileList.push(x_array);
        }

        visibleRegion.setTo(MapsData[0].length * TileSize, MapsData.length * TileSize);
        CurrentPos.setTo(StartPos.x, StartPos.y);
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

        logText.format.setTo(BitmapFont.MINI, 32, 0x1f008d);
        logText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        logText.x = logText.y = 5;
        game.addChild(logText);
    }

    override public function update(dt:Float):Void {
        // controll camera
        if (input.isHeld(Keyboard.W)) {
            camera.y -= cameraSpeed;
            updateTile("up");
        }
        if (input.isHeld(Keyboard.S)) {
            camera.y += cameraSpeed;
            updateTile("down");
        }
        if (input.isHeld(Keyboard.A)) {
            camera.x -= cameraSpeed;
            updateTile("left");
        }
        if (input.isHeld(Keyboard.D)) {
            camera.x += cameraSpeed;
            updateTile("right");
        }

        if (input.isHeld(Keyboard.SPACE)) game.scene = new Tilemap_1();

        camera.x = MathUtil.clamp(camera.x, -(StartPos.x * TileSize), (MapsData[0].length - StartPos.x - VisibleTileWidth ) * TileSize);
        camera.y = MathUtil.clamp(camera.y, -(StartPos.y * TileSize), (MapsData.length - StartPos.y - VisibleTileHeight) * TileSize);
        
        // logText.text = "CamPos: " + (camera.x + (VisibleTileWidth) * TileSize);
        // logText.text += "\nTilePos: " + (TileList[0][TileList[0].length - 1].x);
        // logText.text += "\nCurPos: " + CurrentPos.x;
        // logText.text += "\nRealCam: " + camera.x;
    }

    private function updateTile(pos:String):Void {
        switch (pos) {
            
            case "left":

                // check right side tile
                if (TileList[0][TileList[0].length - 1].x >= camera.x + (VisibleTileWidth) * TileSize) {
                    CurrentPos.x--;
                    CurrentPos.x = MathUtil.clamp(CurrentPos.x, -1, MapsData[0].length - VisibleTileWidth);
                    for (y in 0...TileList.length) {
                        // move tile
                        TileList[y][TileList[0].length - 1].x = TileList[y][0].x - TileSize;
                        TileList[y][TileList[0].length - 1].texture = getTexture(Std.int(CurrentPos.x), Std.int(y + CurrentPos.y));

                        // move tile in TileList
                        TileList[y].insert(0, TileList[y].pop());
                    }
                }

            case "right":
                // check left side tile
                if (TileList[0][0].x + TileSize <= camera.x) {
                    CurrentPos.x++;
                    CurrentPos.x = MathUtil.clamp(CurrentPos.x, -1, MapsData[0].length - VisibleTileWidth);
                    for (y in 0...TileList.length) {
                        // move tile
                        TileList[y][0].x = TileList[y][TileList[0].length - 1].x + TileSize;
                        TileList[y][0].texture = getTexture(Std.int(CurrentPos.x) + VisibleTileWidth, Std.int(y + CurrentPos.y));

                        // move tile in TileList
                        TileList[y].push(TileList[y].shift());
                    }
                }
            
            
            case "down":
                // check top side tile
                if (TileList[0][0].y + TileSize <= camera.y) {
                    CurrentPos.y++;
                    CurrentPos.y = MathUtil.clamp(CurrentPos.y, -1, MapsData.length - VisibleTileHeight);
                    for (x in 0...TileList[0].length) {
                        // move tile
                        TileList[0][x].y = TileList[TileList.length - 1][x].y + TileSize;
                        TileList[0][x].texture = getTexture(Std.int(x + CurrentPos.x), Std.int(CurrentPos.y) + VisibleTileHeight);
                    }
                    // move tile in TileList
                    TileList.push(TileList.shift());
                }
            
            case "up":
                // check bottom side tile
                if (TileList[VisibleTileHeight - 1][0].y >= camera.y + VisibleTileHeight * TileSize) {
                    CurrentPos.y--;
                    CurrentPos.y = MathUtil.clamp(CurrentPos.y, 0, MapsData.length - VisibleTileHeight);
                    trace(CurrentPos.y);
                    for (x in 0...VisibleTileWidth) {
                        // move tile
                        TileList[VisibleTileHeight - 1][x].y = TileList[0][x].y - TileSize;
                        TileList[VisibleTileHeight - 1][x].texture = getTexture(Std.int(x + CurrentPos.x), Std.int(CurrentPos.y));
                    }
                    // move tile in TileList
                    TileList.insert(0, TileList.pop());
                }

        }
    }

    private function getTexture(x:Int, y:Int):Texture {
        // trace(x, y, MapsData[y].charAt(x));

        if (y >= MapsData.length || y < 0 || x >= MapsData[0].length || x < 0) return _ng.assetManager.getTexture("tile2");

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