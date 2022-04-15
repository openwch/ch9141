package cn.wch.ch9140uart.storage;

/**
 * 保存串口状态
 */
public class SerialStatusBean {
    SerialBaudBean serialBaudBean;

    SerialModemBean serialModemBean;

    public SerialStatusBean(SerialBaudBean serialBaudBean, SerialModemBean serialModemBean) {
        this.serialBaudBean = serialBaudBean;
        this.serialModemBean = serialModemBean;
    }

    public SerialBaudBean getSerialBaudBean() {
        return serialBaudBean;
    }

    public void setSerialBaudBean(SerialBaudBean serialBaudBean) {
        this.serialBaudBean = serialBaudBean;
    }

    public SerialModemBean getSerialModemBean() {
        return serialModemBean;
    }

    public void setSerialModemBean(SerialModemBean serialModemBean) {
        this.serialModemBean = serialModemBean;
    }
}
