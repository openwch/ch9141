package cn.wch.ch9140uart.serial;

public class ModemParse {
    /**
     * 判断串口状态，即发送空中断
     * @param data
     * @return
     */
    public static boolean getStatus(byte[] data){
        if(data==null || data.length!=7){
            return false;
        }
        if(data[0]!=(byte)0x88 ){
            return false;
        }
        boolean r=(data[4] & 0x01) ==0x01;
        return r;
    }

    /**
     * 判断DCD是否有效
     * @param data MODEM状态字段
     * @return
     */
    public static boolean isDCDValid(byte data){
        return (data & 0x80)==0x80;
    }

    /**
     * 判断RI是否有效
     * @param data MODEM状态字段
     * @return
     */
    public static boolean isRIValid(byte data){
        return (data & 0x40)==0x40;
    }

    /**
     * 判断DSR是否有效
     * @param data MODEM状态字段
     * @return
     */
    public static boolean isDSRValid(byte data){
        return (data & 0x20)==0x20;
    }

    /**
     * 判断CTS是否有效
     * @param data MODEM状态字段
     * @return
     */
    public static boolean isCTSValid(byte data){
        return (data & 0x10)==0x10;
    }
}
