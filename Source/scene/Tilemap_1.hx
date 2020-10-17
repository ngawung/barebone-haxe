package scene;

import starling.display.Image;
import ngawung.core.Scene;

class Tilemap_1 extends Scene {

    private var TileSize:Int = 64;

    private var VisibleTileWidth:Int = 12;
    private var VisibleTileHeight:Int = 7;

    private var MapsData:Array<String> = [];
    private var TileList:Array<Image> = [];

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
        for(x in 0...VisibleTileWidth) {
            for(y in 0...VisibleTileHeight) {
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
        
    }

    override public function update(dt:Float):Void {
        
    }

}