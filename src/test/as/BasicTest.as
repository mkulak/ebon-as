package {
import com.xap4o.EBON;

import flash.utils.Dictionary;

import flexunit.framework.TestCase;

public class BasicTest extends TestCase {
    public function testInt():void {
        var a:int = 1
        var b:int = EBON.deserialize(EBON.serialize(a))
        assertEquals(a, b)
    }

    public function testNumber():void {
        var a:Number = Math.random() * Number.MAX_VALUE
        var b:Number = EBON.deserialize(EBON.serialize(a))
        assertEquals(a, b)
    }

    public function testString():void {
        var a:String = "quick brown fox jumps over the lazy dog"
        var b:String = EBON.deserialize(EBON.serialize(a))
        assertEquals(a, b)
    }

    public function testArray():void {
        var a:Array = [1, "abc", -3.2, Number(4)]
        var b:Array = EBON.deserialize(EBON.serialize(a))
        assertEquals(a.length, b.length)
        for (var i:int = 0; i < a.length; i++) {
            assertEquals(a[i], b[i])
        }
    }

    public function testDictionary():void {
        var a:Dictionary = new Dictionary()
        a[""] = 1
        a["abc"] = "foo-bar-baz"
        a["some key"] = ["abc", 90, 0.99999]
        a[42] = "string value"
        a[Number(76)] = 0
        var b:Dictionary = EBON.deserialize(EBON.serialize(a))
        for (var key:String in a) {
            assertEq(a[key], b[key])
        }
        for (var key2:String in b) {
            assertEq(b[key2], a[key2])
        }
    }

    //to fix native assertEquals fail for arrays
    public function assertEq(a:*,  b:*):void {
        if (a is Array) {
            assertEq(a.length, b.length)
            for (var i:int = 0; i < a.length; i++) {
                assertEquals(a[i], b[i])
            }
        } else {
            assertEquals(a, b)
        }
    }

    public function testCustomClass():void {
        var f:Foo = new Foo()
        f.a = 2
        f.bar = Number.MAX_VALUE
        f.c = true
        f.stringField = "some string"
        var newF:Foo = EBON.deserialize(EBON.serialize(f))
        assertEquals(f.a, newF.a)
        assertEquals(f.bar, newF.bar)
        assertEquals(f.c, newF.c)
        assertEquals(f.stringField, newF.stringField)
    }

    public function testInnerObjects():void {
        var b1:Bar = new Bar(int.MAX_VALUE, Number.MIN_VALUE + 10, new Foo(), new Bar(51, -0.1, null, null))
        var b2:Bar = EBON.deserialize(EBON.serialize(b1))
        assertTrue(b1.equals(b2))
    }
}
}
