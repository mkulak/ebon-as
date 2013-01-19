package com.xap4o {
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

public class EBONSerializer {
    private var buf:ByteArray = new ByteArray()
    private var refMap:Dictionary = new Dictionary() //<Object, int>
    private var nextRef:int

    public function serialize(value:*):ByteArray {
        writeValue(value)
        buf.position = 0
        return buf
    }

    private function writeValue(value:*):void {
        if (value == null) {
            buf.writeByte(EBON.C_NULL)
            return
        }
        if (refMap[value] != null) {
            buf.writeByte(EBON.C_REF)
            buf.writeInt(int(refMap[value]))
            return
        }
        if (value is Boolean) {
            buf.writeByte(EBON.C_BOOLEAN)
            buf.writeByte(Boolean(value) ? 1 : 0)
        } else if (value is int) {
            buf.writeByte(EBON.C_INT)
            buf.writeInt(int(value))
        } else if (value is Number) {
            buf.writeByte(EBON.C_DOUBLE)
            buf.writeDouble(Number(value))
        } else if (value is String) {
            writeString(String(value))
        } else if (value is ByteArray) {
            writeByteArray(ByteArray(value))
        } else if (value is Array) {
            writeList(value as Array)
        } else if (value is Dictionary) {
            writeMap(Dictionary(value))
        } else {
            writeObject(value)
        }
    }

    private function writeString(str:String):void {
        if (refMap.hasOwnProperty(str)) {
            buf.writeByte(EBON.C_REF)
            buf.writeInt(int(refMap[str]))
        } else {
            buf.writeByte(EBON.C_STRING)
            buf.writeInt(saveRef(str))
            buf.writeInt(str.length)
            buf.writeUTFBytes(str)
        }
    }

    private function writeObject(doc:Object):void {
        buf.writeByte(EBON.C_OBJECT)
        buf.writeInt(saveRef(doc))
        writeString(getQualifiedClassName(doc))
        var sizePos:int = buf.position
        buf.writeInt(0)//to reserve space for actual fieldsCount value
        var fieldsCount:int = 0
        var fieldsList:XMLList = describeType(doc)..variable
        for(var i:int; i < fieldsList.length(); i++){
            //TODO: handle [Skip] annotation
            var fieldName:String = fieldsList[i].@name;
            writeString(fieldName)
            writeValue(doc[fieldName])
            fieldsCount++
        }
//        TODO: handle [Getter] annotation
        var endPos:int = buf.position
        buf.position = sizePos
        buf.writeInt(fieldsCount)
        buf.position = endPos
    }

    private function writeMap(dict:Dictionary):void {
        buf.writeByte(EBON.C_MAP)
        buf.writeInt(saveRef(dict))
        var sizePos:int = buf.position
        buf.writeInt(0)
        var size:int = 0
        for (var key:* in dict) {
            writeValue(key)
            writeValue(dict[key])
            size++
        }
        var endPos:int = buf.position
        buf.position = sizePos
        buf.writeInt(size)
        buf.position = endPos
    }

    private function writeList(arr:Array):void {
        buf.writeByte(EBON.C_LIST)
        buf.writeInt(saveRef(arr))
        buf.writeInt(arr.length)
        for each(var e:* in arr) {
            writeValue(e)
        }
    }

    private function writeByteArray(value:ByteArray):void {
        buf.writeByte(EBON.C_BINARY)
        buf.writeInt(saveRef(value))
        buf.writeInt(value.length)
        buf.writeBytes(value)
    }

    private function saveRef(value:*):int {
        var ref:int = nextRef
        nextRef++
        refMap[value] = ref
        return ref
    }
}
}
