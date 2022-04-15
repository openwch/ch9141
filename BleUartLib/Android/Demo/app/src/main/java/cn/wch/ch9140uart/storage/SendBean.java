package cn.wch.ch9140uart.storage;

import java.io.File;

import androidx.annotation.NonNull;
import cn.wch.ch9140uart.task.SendType;
/**
 * 保存发送状态
 */
public class SendBean {
    SendType type=SendType.TYPE_SINGLE;
    File file;
    long interval;

    /**
     * 单次
     * @param type
     */
    public SendBean(SendType type) {
        this.type = type;
    }


    /**
     * 定时、连续
     * @param type
     */
    public SendBean(SendType type, long interval) {
        this.type = type;
        this.interval = interval;
    }

    /**
     * 文件
     * @param type
     * @param file
     */
    public SendBean(SendType type, @NonNull File file) {
        this.type = type;
        this.file = file;
    }

    public SendType getType() {
        return type;
    }

    public void setType(SendType type) {
        this.type = type;
    }

    public File getFile() {
        return file;
    }

    public void setFile(@NonNull File file) {
        this.file = file;
    }

    public long getInterval() {
        return interval;
    }

    public void setInterval(long interval) {
        this.interval = interval;
    }

    @NonNull
    @Override
    public String toString() {
        if(type==null){
            return "未定义的模式";
        }else if (type==SendType.TYPE_SINGLE){
            return "单次发送";
        }else if (type==SendType.TYPE_TIMING){
            return "定时发送，间隔"+interval+"ms";
        }else if (type==SendType.TYPE_CYCLIC){
            return "连续发送";
        }else if (type==SendType.TYPE_FILE){
            return "文件发送:"+(file==null ? "空":file.getName());
        }else {
            return "未定义的发送模式";
        }
    }
}
