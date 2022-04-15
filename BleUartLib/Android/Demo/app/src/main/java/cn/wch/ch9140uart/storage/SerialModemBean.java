package cn.wch.ch9140uart.storage;

import androidx.annotation.NonNull;

public class SerialModemBean {
    boolean flow;
    int DTR;
    int RTS;


    public boolean isFlow() {
        return flow;
    }

    public void setFlow(boolean flow) {
        this.flow = flow;
    }

    public int getDTR() {
        return DTR;
    }

    public void setDTR(int DTR) {
        this.DTR = DTR;
    }

    public int getRTS() {
        return RTS;
    }

    public void setRTS(int RTS) {
        this.RTS = RTS;
    }

    @NonNull
    @Override
    public String toString() {
        return "流控："+(flow? "开" : "关");
    }
}
