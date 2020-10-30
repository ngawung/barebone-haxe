package ngawung.display;

interface Atom {
    public function update(dt:Float):Void;
    public function destroy(removeFromParent:Bool = false):Void;
    public function resize():Void;
}