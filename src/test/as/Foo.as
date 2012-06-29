package {
public class Foo {
    public var a:int
    public var bar:Number = 1
    public var c:Boolean
    public var stringField:String

    public function equals(o:Foo):Boolean {
        return (a == o.a) && (bar = o.bar) && (c == o.c) && (stringField == o.stringField)
    }


    public function toString():String {
        return "Foo{a=" + String(a) + ",bar=" + String(bar) + ",c=" + String(c) + ",stringField=" + String(stringField) + "}";
    }
}
}
