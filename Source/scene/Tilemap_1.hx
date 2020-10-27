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
    
    private var player:Image;
    private var playerSpeed:Int = 5;

    private var logText:TextField = new TextField(0, 0, "");
    private var logQuad:Quad = new Quad(15, 15, 0xff00fa);

    public function new() {
        super();

        MapsData.push(".#....#....#...........................");
        MapsData.push(".#....#....#...........................");
        MapsData.push("...........................####........");
        MapsData.push(".#....#....#...........................");
        MapsData.push(".......................................");
        MapsData.push(".......................................");
        MapsData.push(".#....#....#####.......................");
        MapsData.push("###.##..###########.######....#########");
        MapsData.push(".........#..........#.......####.......");
        MapsData.push(".........#.##########....####..........");
        MapsData.push(".........#..............####...........");
        MapsData.push(".........################..............");
        MapsData.push(".......................................");
        
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

        player = new Image(_ng.assetManager.getTexture("player"));
        player.pivotX = player.width / 2;
        player.pivotY = player.height / 2;
        player.x = 3 * TileSize + TileSize / 2;
        player.y = 2 * TileSize + TileSize / 2;
        addChild(player);

        // // array testing
        // var a:Array<Int> = [0,1,2,3,4,5,6,7,8,9];
        // a.insert(4, 99);
        // trace(a.concat(a.splice(0, 5)));

        logText.format.setTo(BitmapFont.MINI, 32, 0x1f008d);
        logText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        logText.x = logText.y = 5;
        game.addChild(logText);

        logQuad.pivotX = logQuad.pivotY = logQuad.width / 2;
        addChild(logQuad);
    }

    override public function update(dt:Float):Void {
        // controll camera
        if (input.isHeld(Keyboard.W)) {
            checkCorner("up");
            updateTile("up");
        }
        if (input.isHeld(Keyboard.S)) {
            checkCorner("down");
            updateTile("down");
        }
        if (input.isHeld(Keyboard.A)) {
            checkCorner("left");
            updateTile("left");
        }
        if (input.isHeld(Keyboard.D)) {
            checkCorner("right");
            updateTile("right");
        }

        if (input.isDown(Keyboard.SPACE)) {
            game.scene = new Tilemap_1();
            return;
        }

        camera.x = player.x - stage.stageWidth / 2;
        camera.y = player.y - stage.stageHeight / 2;

        camera.x = MathUtil.clamp(camera.x, -(StartPos.x * TileSize), (MapsData[0].length - StartPos.x - VisibleTileWidth ) * TileSize);
        camera.y = MathUtil.clamp(camera.y, -(StartPos.y * TileSize), (MapsData.length - StartPos.y - VisibleTileHeight) * TileSize);
    }

    private function updateTile(pos:String):Void {
        switch (pos) {
            
            case "left":

                // check right side tile
                if (TileList[0][TileList[0].length - 1].x >= camera.x + VisibleTileWidth * TileSize) {
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
                if (TileList[TileList.length - 1][0].y >= camera.y + VisibleTileHeight * TileSize) {
                    CurrentPos.y--;
                    CurrentPos.y = MathUtil.clamp(CurrentPos.y, -1, MapsData.length - VisibleTileHeight);
                    for (x in 0...TileList[0].length) {
                        // move tile
                        TileList[TileList.length - 1][x].y = TileList[0][x].y - TileSize;
                        TileList[TileList.length - 1][x].texture = getTexture(Std.int(x + CurrentPos.x), Std.int(CurrentPos.y));
                    }
                    // move tile in TileList
                    TileList.insert(0, TileList.pop());
                }

        }
    }

    private function checkCorner(direction:String):Void {
        switch (direction) {
            case "left":
                var upX:Int = Math.floor(((player.x - player.width / 2 ) - playerSpeed) / TileSize);
                var upY:Int = Math.floor((player.y - (player.height / 2) + 1) / TileSize);
                var downX:Int = Math.floor(((player.x - player.width / 2) - playerSpeed) / TileSize);
                var downY:Int = Math.floor((player.y + (player.height / 2) - 1) / TileSize);

                if (MapsData[upY].charAt(upX) == "#") {
                    player.x = upX * TileSize + player.width / 2 + TileSize;
                } else if (MapsData[downY].charAt(downX)  == "#") {
                    player.x = downX * TileSize + player.width / 2 + TileSize;
                } else {
                    player.x -= playerSpeed;
                }

            case "right":
                var upX:Int = Math.floor(((player.x + player.width / 2 ) + playerSpeed) / TileSize);
                var upY:Int = Math.floor((player.y - (player.height / 2) + 1) / TileSize);
                var downX:Int = Math.floor(((player.x + player.width / 2) + playerSpeed) / TileSize);
                var downY:Int = Math.floor((player.y + (player.height / 2) - 1) / TileSize);

                if (MapsData[upY].charAt(upX) == "#") {
                    player.x = upX * TileSize - player.width / 2;
                } else if (MapsData[downY].charAt(downX)  == "#") {
                    player.x = downX * TileSize - player.width / 2;
                } else {
                    player.x += playerSpeed;
                }

            case "down":
                var downLX:Int = Math.floor(((player.x - player.width / 2) + 1) / TileSize);
                var downLY:Int = Math.floor((player.y + (player.height / 2) + playerSpeed) / TileSize);
                var downRX:Int = Math.floor(((player.x + player.width / 2) - 1) / TileSize);
                var downRY:Int = Math.floor((player.y + (player.height / 2) + playerSpeed) / TileSize);

                if (MapsData[downLY].charAt(downLX) == "#") {
                    player.y = downLY * TileSize - player.height / 2;
                } else if (MapsData[downRY].charAt(downRX)  == "#") {
                    player.y = downRY * TileSize - player.height / 2;
                } else {
                    player.y += playerSpeed;
                }

            case "up":
                var upLX:Int = Math.floor(((player.x - player.width / 2) + 1) / TileSize);
                var upLY:Int = Math.floor((player.y - (player.height / 2) - playerSpeed) / TileSize);
                var upRX:Int = Math.floor(((player.x + player.width / 2) - 1) / TileSize);
                var upRY:Int = Math.floor((player.y - (player.height / 2) - playerSpeed) / TileSize);

                if (MapsData[upLY].charAt(upLX) == "#") {
                    player.y = upLY * TileSize + player.height / 2 + TileSize;
                } else if (MapsData[upRY].charAt(upRX)  == "#") {
                    player.y = upRY * TileSize + player.height / 2 + TileSize;
                } else {
                    player.y -= playerSpeed;
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