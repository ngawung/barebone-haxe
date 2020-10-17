package ngawung.display;

interface Atom {
    public var layer:Int;

    public function init():Void;
    public function update(dt:Float):Void;
    public function destroy():Void;
}