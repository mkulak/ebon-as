package com.xap4o {
import flash.utils.ByteArray;

public class EBON {
    public static const C_NULL:int = 0
    public static const C_BOOLEAN:int = 1
    public static const C_INT:int = 2
    public static const C_LONG:int = 3
    public static const C_DOUBLE:int = 4
    public static const C_STRING:int = 5
    public static const C_LIST:int = 6
    public static const C_OBJECT:int = 7
    public static const C_BINARY:int = 8
    public static const C_MAP:int = 9
    public static const C_ENUM:int = 10
    public static const C_REF:int = 11

    public static function serialize(value:*):ByteArray {
        return new EBONSerializer().serialize(value)
    }
    public static function deserialize(bytes:ByteArray):* {
        return new EBONDeserializer().deserialize(bytes)
    }
}
}