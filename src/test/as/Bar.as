package {
public class Bar {
    public var d:int
    public var numberField:Number
    public var ref:Foo
    public var ref2:Bar


    public function Bar(d:int = 0, numberField:Number = 0, ref:Foo = null, ref2:Bar = null) {
        this.d = d
        this.numberField = numberField
        this.ref = ref
        this.ref2 = ref2
    }

    public function equals(o:Bar):Boolean {
        return (d == o.d) && (numberField == o.numberField) && ((ref == o.ref) || ref.equals(o.ref)) && ((ref2 == o.ref2) || ref2.equals(o.ref2))
    }


    public function toString():String {
        return "Bar{d=" + String(d) + ",numberField=" + String(numberField) + ",ref=" + String(ref) + ",ref2=" + String(ref2) + "}";
    }
}
}
