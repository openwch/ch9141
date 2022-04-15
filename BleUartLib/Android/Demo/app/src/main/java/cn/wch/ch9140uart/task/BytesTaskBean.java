package cn.wch.ch9140uart.task;


public class BytesTaskBean {


    private byte[] data;
    private long interval;

    public BytesTaskBean( byte[] data) {

        this.data = data;
    }

    public BytesTaskBean(byte[] data, long interval) {

        this.data = data;
        this.interval = interval;
    }


    public byte[] getData() {
        return data;
    }

    public long getInterval() {
        return interval;
    }
}
