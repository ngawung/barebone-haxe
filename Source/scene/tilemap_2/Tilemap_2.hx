package scene.tilemap_2;

import ngawung.core.Scene;

// contain much cleaner version of Tilemap_1

class Tilemap_2 extends Scene {

    private var MapsData:Array<String> = [];

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
        MapsData.push(".2.......#.........###########.2.4.6.8.");
        MapsData.push("..3......#.........#.........##########");
        MapsData.push("...4.....#.........#.........#.........");
        MapsData.push("######.###########.######....#########.");
        MapsData.push("#1......#..........#.......####.....89#");
        MapsData.push("..2.....#.##########....####.......7..1");
        MapsData.push("...3....#..........#...####.......6...2");
        MapsData.push("....4...################.........5....3");
        MapsData.push("##########...5.....#....5.......4.....4");
        MapsData.push("##1.....#...4.6....#...4.6.....3......5");
        MapsData.push("...2....#..3...7...#..3...7...2.......6");
        MapsData.push("....3...#.2.....8..#.2.....8.1........7");
        MapsData.push(".....4..#1.......9##1.......9.........8");

        // add tile to TileList
        
    
    }

    override function update(dt:Float):Void {
        
    }

}