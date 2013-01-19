package com.xap4o {
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

public class EBONDeserializer {
    private var buf:ByteArray
    private var refMap:Dictionary = new Dictionary() //<int, Object>

    public function deserialize(bytes:ByteArray):* {
        buf = bytes
        return readValue()
    }

    private function readValue():* {
        var valType:int = buf.readByte()
        switch (valType) {
            case EBON.C_NULL:
                return null
            case EBON.C_BOOLEAN:
                return buf.readByte() == 1
            case EBON.C_INT:
                return buf.readInt()
            case EBON.C_LONG:
                return buf.readInt()//todo: fix it
            case EBON.C_DOUBLE:
                return buf.readDouble()
            case EBON.C_STRING:
                return readStringImpl()
            case EBON.C_BINARY:
                return readByteArray()
            case EBON.C_LIST:
                return readList()
            case EBON.C_MAP:
                return readMap()
            case EBON.C_OBJECT:
                return readObject()
            case EBON.C_ENUM:
                return readEnum()
            case EBON.C_REF:
                return readRef()
        }
        throw new EBONException("Unsupported type: " + valType)
    }

    private function readRef():* {
        var ref:int = buf.readInt()
        var res:* = refMap[ref]
        if (res == null) {
            throw new EBONException("Malformed ref " + ref)
        }
        return res
    }

    private function readEnum():String {
        var clazzName:String = readString()
        var name:String = readString()
        return name
    }

    private function readObject():Object {
        var ref:int = buf.readInt()
        var className:String = readString()
        var fieldsCount:int = buf.readInt()
        var clazz:Class = getDefinitionByName(className) as Class
        var res:Object = new clazz()
        refMap[ref] = res
        for (var i:int = 0; i < fieldsCount; i++) {
            var name:String = readString()
            var value:* = readValue()
            res[name] = value
        }
        return res
    }

    private function readString():String {
        var valType:int = buf.readByte()
        switch (valType) {
            case EBON.C_STRING:
                return readStringImpl()
            case EBON.C_REF:
                return String(readRef())
            default:
                throw new EBONException("Expected string, found " + valType);
        }
    }

    private function readStringImpl():String {
        var ref:int = buf.readInt()
        var size:int = buf.readInt()
        var res:String = buf.readUTFBytes(size);
        refMap[ref] = res
        return res
    }

    private function readByteArray():ByteArray {
        var ref:int = buf.readInt()
        var res:ByteArray = new ByteArray()
        var size:int = buf.readInt()
        buf.readBytes(res, 0, size)
        refMap[ref] = res
        return res
    }

    private function readMap():Dictionary {
        var ref:int = buf.readInt()
        var size:int = buf.readInt()
        var res:Dictionary = new Dictionary()
        refMap[ref] = res
        for (var i:int = 0; i < size; i++) {
            var key:* = readValue()
            res[key] = readValue()
        }
        return res
    }

    private function readList():Array {
        var ref:int = buf.readInt()
        var size:int = buf.readInt()
        var res:Array = []
        refMap[ref] = res
        for (var i:int = 0; i < size; i++) {
            res.push(readValue())
        }
        return res
    }
}
}
