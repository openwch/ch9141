package cn.wch.ch9140uart.serial;

public class AckParseUtil {

    public static boolean isValidBaudRateAck(byte[] source){
        if(source==null || source.length!=12){
            return false;
        }
        return source[0]==(byte)0x86;
    }

    public static boolean isValidFlowAck(byte[] source){
        if(source==null || source.length!=8){
            return false;
        }
        return source[0]==(byte)0x87;
    }
}
