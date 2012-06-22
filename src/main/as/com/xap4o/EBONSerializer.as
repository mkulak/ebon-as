package com.xap4o {
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

public class EBONSerializer {
    private var buf:ByteArray = new ByteArray()

    public function serialize(value:*):ByteArray {
        writeValue(value)
        buf.position = 0
        return buf
    }

    private function writeObject(doc:Object):void {
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

    private function writeString(str:String):void {
        buf.writeInt(str.length)
        buf.writeUTFBytes(str)
    }

    private function writeValue(value:*):void {
        if (value == null) {
            buf.writeByte(EBON.C_NULL);
            return;
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
            buf.writeByte(EBON.C_STRING)
            writeString(String(value))
        } else if (value is ByteArray) {
            buf.writeByte(EBON.C_BINARY)
            writeByteArray(ByteArray(value))
        } else if (value is Array) {
            buf.writeByte(EBON.C_LIST)
            writeList(value as Array)
        } else if (value is Dictionary) {
            buf.writeByte(EBON.C_MAP)
            writeMap(Dictionary(value))
        } else {
            buf.writeByte(EBON.C_OBJECT)
            writeObject(value)
        }
    }

    private function writeMap(dict:Dictionary):void {
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
        buf.writeInt(arr.length)
        for each(var e:* in arr) {
            writeValue(e)
        }
    }

    private function writeByteArray(value:ByteArray):void {
        buf.writeInt(value.length)
        buf.writeBytes(value)
    }
}
}
