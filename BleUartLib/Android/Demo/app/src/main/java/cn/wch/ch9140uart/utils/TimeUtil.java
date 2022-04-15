package cn.wch.ch9140uart.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class TimeUtil {

    private static SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss:SSS", Locale.getDefault());
    private static SimpleDateFormat simpleFormat=new SimpleDateFormat("yyyy-MM-dd",Locale.getDefault());
    private static SimpleDateFormat fileFormat=new SimpleDateFormat("yyyyMMddHHmmss",Locale.getDefault());

    public static String getCurrentTime(){
        return format.format(new Date());
    }

    public static String parseFrom(Date date){
        return  simpleFormat.format(date);
    }
    public static Date parseFrom(String data)throws ParseException {
        return  simpleFormat.parse(data);
    }

    /**
     * 用做文件命名
     * @return
     */
    public static String getCurrentTimeForFile(){
        return fileFormat.format(new Date());
    }
}
