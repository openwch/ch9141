package cn.wch.ch9140uart.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import androidx.annotation.NonNull;

public class FileUtil {
    public static void writeDataToFile(@NonNull byte[] data, @NonNull File file) throws Exception {
        if(!file.exists()){
            throw new Exception("file doesn't exist");
        }
        FileOutputStream fileOutputStream=null;
        try {
            fileOutputStream = new FileOutputStream(file);
            fileOutputStream.write(data);
            fileOutputStream.flush();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(fileOutputStream!=null){
                try {
                    fileOutputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    /**
     * 84C2E4090909_202007292030.log
     * @param mac
     * @return
     */
    public static String getRandomName(String mac){
        return mac.replace(":","")+"_"+TimeUtil.getCurrentTimeForFile();
    }


}
