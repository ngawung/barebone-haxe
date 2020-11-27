package scene.tilemap_2;

import openfl.ui.Keyboard;
import ngawung.core.Scene;

// contain much cleaner version of Tilemap_1

class Tilemap_2 extends Scene {
    private var TileSize:Int = 64;
    private var MapsData:Array<String> = [];
    private var layer:TileLayer;

    private var cameraSpeed:Int = 5;

    public function new() {
        super();

    }

    override function init():Void {
        trace("Initialize Tilemap_2");
        camera.enable = true;

        MapsData.push("1.3.5.7.9#.........#.........#.........");
        MapsData.push(".2.4.6.8.#1.3.5.7.9#.........#.........");
        MapsData.push("##########.2.4.6.8.#1.3.5.7.9#.........");
        MapsData.push("1........###########.2.4.6.8.#1.3.5.7.9");
        MapsData.push(".2...#...#.........###########.2.4.6.8.");
        MapsData.push("..3......#.........#.........##########");
        MapsData.push("...4.....#.........#.........#.........");
        MapsData.push("######.###########.######....#########.");
        MapsData.push("#1...#..#..........#.......####.....89#");
        MapsData.push("..2..#..#.##########....####.......7..1");
        MapsData.push("...3....#..........#...####.......6...2");
        MapsData.push("....4...################.........5....3");
        MapsData.push("##########...5.....#....5.......4.....4");
        MapsData.push("##1..##.#...4.6....#...4.6.....3......5");
        MapsData.push("...2.#..#..3...7...#..3...7...2.......6");
        MapsData.push("....3...#.2.....8..#.2.....8.1........7");
        MapsData.push(".....4..#1.......9##1.......9.........8");

        var tileConf_list:Array<TileConfig> = [
            new TileConfig(".", "tile2"),
            new TileConfig("#", "tile1"),
            new TileConfig("1", "1"),
            new TileConfig("2", "2"),
            new TileConfig("3", "3"),
            new TileConfig("4", "4"),
            new TileConfig("5", "5"),
            new TileConfig("6", "6"),
            new TileConfig("7", "7"),
            new TileConfig("8", "8"),
            new TileConfig("9", "9"),
        ];
        
        var conf:MapConfig = new MapConfig(MapsData, TileSize, tileConf_list);

        // camera.x = -(TileSize * 5);
        // camera.y = -(TileSize * 5);

        layer = new TileLayer(conf);
        addChild(layer);
    }

    override function update(dt:Float):Void {
        if (input.isHeld(Keyboard.W)) camera.y -= cameraSpeed;
        if (input.isHeld(Keyboard.S)) camera.y += cameraSpeed;
        if (input.isHeld(Keyboard.A)) camera.x -= cameraSpeed;
        if (input.isHeld(Keyboard.D)) camera.x += cameraSpeed;
    }

    override function resize() {
        
    }

    override function cameraUpdate() {
        // layer.clampCamera();
        // layer.updatePos();
    }

}