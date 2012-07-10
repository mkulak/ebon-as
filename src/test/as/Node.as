package {
public class Node {
    public var children:Array
    public var value:int
    public var parent:Node

    public function Node(value:int = 0, children:Array = null) {
        this.value = value
        this.children = children != null ? children : []
        for each(var child:Node in this.children) {
            child.parent = this
        }
    }
}
}
