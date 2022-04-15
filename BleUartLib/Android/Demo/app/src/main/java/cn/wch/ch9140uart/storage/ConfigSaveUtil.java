package cn.wch.ch9140uart.storage;

/**
 * 获取各个dialog的状态
 */
public class ConfigSaveUtil {

    private static ConfigSaveUtil configSaveUtil;
    public static ConfigSaveUtil getInstance() {
        if(configSaveUtil==null){
            synchronized (ConfigSaveUtil.class){
                configSaveUtil=new ConfigSaveUtil();
            }
        }
        return configSaveUtil;
    }

    //接受数据状态
    private SaveBean saveBean;
    //发送数据状态
    private SendBean sendBean;
    //串口设置状态
    private SerialStatusBean serialStatusBean;


    public SaveBean getSaveStatus(){
        return saveBean;
    }

    public void setSaveBean(SaveBean saveBean) {
        this.saveBean = saveBean;
    }

    public void setSendBean(SendBean sendBean) {
        this.sendBean = sendBean;
    }

    public SendBean getSendStatus() {
        return sendBean;
    }

    public SerialStatusBean getSerialStatusBean() {
        if( serialStatusBean==null){
            serialStatusBean=getDefaultStatus();
        }
        return serialStatusBean;
    }

    public void setSerialStatusBean(SerialStatusBean serialStatusBean) {

        this.serialStatusBean = serialStatusBean;
    }



    private SerialStatusBean getDefaultStatus(){
        //默认配置
        SerialBaudBean serialBaudBean=new SerialBaudBean();
        serialBaudBean.setBaud(115200);
        serialBaudBean.setData(8);
        serialBaudBean.setStop(1);
        serialBaudBean.setParity(0);

        SerialModemBean serialModemBean=new SerialModemBean();
        serialModemBean.setFlow(false);
        serialModemBean.setDTR(1);
        serialModemBean.setRTS(1);

        return new SerialStatusBean(serialBaudBean,serialModemBean);
    }

}
