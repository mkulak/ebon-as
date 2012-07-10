package {
public class Node {
    public var children:Array = []
    public var value:int
    public var parent:Node

    public function Node(value:int, children:Array) {
        this.value = value
        this.children = children
        for each(var child:Node in children) {
            child.parent = this
        }
    }
}
}
