package cn.wch.ch9140uart.serial;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class CommandUtil {

    public static byte[] getBaudRateCommand(int baudRate,int dataBit,int stopBit,int parity){
        ByteBuffer byteBuffer=ByteBuffer.allocate(11).order(ByteOrder.LITTLE_ENDIAN);
        byteBuffer.put(CommandCode.SET_BAUD);
        byteBuffer.put(new byte[]{0x00,0x09});
        byteBuffer.put((byte) 0x00);
        byteBuffer.putInt(baudRate);
        byteBuffer.put((byte)dataBit);
        byteBuffer.put((byte)stopBit);
        byteBuffer.put((byte)parity);
        byte[] array = byteBuffer.array();
        return computeSum(array);
    }

    public static byte[] getFlowCommand(boolean flow,int DTR,int RTS){
        ByteBuffer byteBuffer=ByteBuffer.allocate(7).order(ByteOrder.LITTLE_ENDIAN);
        byteBuffer.put(CommandCode.SET_FLOW);
        byteBuffer.put(new byte[]{0x00,0x05});
        byteBuffer.put((byte) 0x00);
        byteBuffer.put(flow ? (byte)0x01 : (byte)0x00);
        byteBuffer.put((byte) DTR);
        byteBuffer.put((byte) RTS);
        byte[] array = byteBuffer.array();
        return computeSum(array);
    }


    public static  byte[] computeSum(byte[] source){
        int sum=0;
        for (int i = 3; i < source.length; i++) {
            sum+=(source[i] & 0xff);
        }
        ByteBuffer byteBuffer=ByteBuffer.allocate(source.length+1);
        byteBuffer.put(source);
        byteBuffer.put((byte)sum);
        return byteBuffer.array();
    }
}
