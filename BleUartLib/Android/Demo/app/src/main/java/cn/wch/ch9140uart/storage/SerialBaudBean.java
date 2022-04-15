package cn.wch.ch9140uart.storage;

import java.util.Locale;

import androidx.annotation.NonNull;

/**
 * 用来发送串口数据
 */
public class SerialBaudBean {
    int baud;
    int data;
    int stop;
    int parity;

    public int getBaud() {
        return baud;
    }

    public void setBaud(int baud) {
        this.baud = baud;
    }

    public int getData() {
        return data;
    }

    public void setData(int data) {
        this.data = data;
    }

    public int getStop() {
        return stop;
    }

    public void setStop(int stop) {
        this.stop = stop;
    }

    public int getParity() {
        return parity;
    }

    public void setParity(int parity) {
        this.parity = parity;
    }



    @NonNull
    @Override
    public String toString() {
        String p;
        switch (parity){
            case 0:
                p="None";
                break;
            case 1:
                p="Odd";
                break;
            case 2:
                p="Even";
                break;
            case 3:
                p="Mark";
                break;
            case 4:
                p="Space";
                break;
            default:
                p="None";
                break;
        }
        return String.format(Locale.US,"%d,%d,%d,"+p,baud,data,stop);
    }
}
