package cn.wch.ch9140uart.ui;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.Spinner;

import com.suke.widget.SwitchButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.MyApplication;
import cn.wch.ch9140uart.R;
import cn.wch.ch9140uart.storage.SerialModemBean;
import cn.wch.ch9140uart.storage.SerialStatusBean;
import cn.wch.ch9140uart.storage.SerialBaudBean;

public class SerialConfigDialog  extends DialogFragment {

    private SerialStatusBean bean;

    private Button confirm;
    private Button cancel;

    private Spinner baud;
    private Spinner data;
    private Spinner stop;
    private Spinner parity;

    private SwitchButton flow;
    private CheckBox cbDTR;
    private CheckBox cbRTS;


    private onClickListener listener;

    private Handler handler=new Handler(Looper.getMainLooper());

    public static SerialConfigDialog newInstance(SerialStatusBean bean) {
        Bundle args = new Bundle();
        SerialConfigDialog fragment = new SerialConfigDialog(bean);
        fragment.setArguments(args);
        return fragment;
    }

    public SerialConfigDialog(SerialStatusBean bean) {
        this.bean = bean;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.dialog_serial, null);
        init(view);
        return view;
    }

    private void init(View view) {
        confirm=view.findViewById(R.id.set);
        cancel=view.findViewById(R.id.cancel);
        flow=view.findViewById(R.id.sb_flow);
        cbDTR=view.findViewById(R.id.cb_dtr);
        cbRTS=view.findViewById(R.id.cb_rts);

        initSpinner(view);
        if(bean!=null){
            loadParameter(bean);
        }

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                dismiss();
            }
        });
        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(listener!=null){
                    listener.onSetBaud(getBaudData());
                }
                dismiss();
            }
        });

        flow.setOnCheckedChangeListener(new SwitchButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(SwitchButton view, boolean isChecked) {
                if(listener!=null){
                    listener.onSetModem(getModemData());
                }
            }
        });

        cbDTR.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(listener!=null){
                    listener.onSetModem(getModemData());
                }
            }
        });

        cbRTS.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(listener!=null){
                    listener.onSetModem(getModemData());
                }
            }
        });
    }
    public void setListener(onClickListener listener){
        this.listener=listener;

    }

    public interface onClickListener{
        void onSetBaud(SerialBaudBean data);
        void onSetModem(SerialModemBean data);
    }

    private void initSpinner(View view){
        baud=view.findViewById(R.id.spinner_baud);
        ArrayAdapter<CharSequence> baudAdapter = ArrayAdapter
                .createFromResource(MyApplication.getContext(), R.array.baud,
                        R.layout.my_spinner_textview);
        baudAdapter.setDropDownViewResource(R.layout.my_spinner_textview);
        baud.setAdapter(baudAdapter);
        baud.setGravity(0x10);
       // baud.setSelection(9);

        data=view.findViewById(R.id.spinner_data);
        ArrayAdapter<CharSequence> dataAdapter = ArrayAdapter
                .createFromResource(MyApplication.getContext(), R.array.data,
                        R.layout.my_spinner_textview);
        baudAdapter.setDropDownViewResource(R.layout.my_spinner_textview);
        data.setAdapter(dataAdapter);
        data.setGravity(0x10);
        //data.setSelection(3);

        stop=view.findViewById(R.id.spinner_stop);
        ArrayAdapter<CharSequence> stopAdapter = ArrayAdapter
                .createFromResource(MyApplication.getContext(), R.array.stop,
                        R.layout.my_spinner_textview);
        baudAdapter.setDropDownViewResource(R.layout.my_spinner_textview);
        stop.setAdapter(stopAdapter);
        stop.setGravity(0x10);
        //stop.setSelection(0);

        parity=view.findViewById(R.id.spinner_parity);
        ArrayAdapter<CharSequence> parityAdapter = ArrayAdapter
                .createFromResource(MyApplication.getContext(), R.array.parity,
                        R.layout.my_spinner_textview);
        baudAdapter.setDropDownViewResource(R.layout.my_spinner_textview);
        parity.setAdapter(parityAdapter);
        parity.setGravity(0x10);
        //parity.setSelection(0);
    }


    /**
     * 加载Dialog状态
     * @param bean
     */
    private void loadParameter(SerialStatusBean bean){
        if(bean==null){
            return;
        }
        if(bean.getSerialBaudBean()!=null){
            SerialBaudBean serialBaudBean = bean.getSerialBaudBean();
            baud.setSelection(getIndexFromStringArray(MyApplication.getContext(),R.array.baud,Integer.toString(serialBaudBean.getBaud())));
            data.setSelection(getIndexFromStringArray(MyApplication.getContext(),R.array.data,Integer.toString(serialBaudBean.getData())));
            stop.setSelection(getIndexFromStringArray(MyApplication.getContext(),R.array.stop,Integer.toString(serialBaudBean.getStop())));
            String parityString="";
            switch (serialBaudBean.getParity()){
                case 0:
                    parityString="无";
                    break;
                case 1:
                    parityString="奇校验";
                    break;
                case 2:
                    parityString="偶校验";
                    break;
                case 3:
                    parityString="标志位";
                    break;
                case 4:
                    parityString="空白位";
                    break;
                default:
                    parityString="无";
                    break;
            }
            parity.setSelection(getIndexFromStringArray(MyApplication.getContext(),R.array.parity,parityString));
        }else {
            LogUtil.d("bean.getSerialBaudBean is null");
        }
        if(bean.getSerialModemBean()!=null){
            SerialModemBean serialModemBean = bean.getSerialModemBean();
            flow.setChecked(serialModemBean.isFlow());
            cbDTR.setChecked(serialModemBean.getDTR()==1);
            cbRTS.setChecked(serialModemBean.getRTS()==1);
            updateRSTStatus(serialModemBean.isFlow());
        }else {
            LogUtil.d("bean.getSerialModemBean is null");
        }
    }

    private int getIndexFromStringArray(Context context, int arrayId, String source){

        String[] stringArray = context.getResources().getStringArray(arrayId);
        for (int i = 0; i < stringArray.length; i++) {
            if(source.equals(stringArray[i])){
                LogUtil.d("初始化: "+source+" 位置："+i);
                return i;
            }
        }
        return 0;
    }

    /**
     * 获取波特率详细信息，用来蓝牙通信
     * @return
     */
    private SerialBaudBean getBaudData(){
        SerialBaudBean bean=new SerialBaudBean();
        bean.setBaud(Integer.parseInt(baud.getSelectedItem().toString()));
        bean.setData(Integer.parseInt(data.getSelectedItem().toString()));
        bean.setStop(Integer.parseInt(stop.getSelectedItem().toString()));
        String p=parity.getSelectedItem().toString();
        LogUtil.d(p);
        int i=0;
        switch (p){
            case "无":
                i=0;
                break;
            case "奇校验":
                i=1;
                break;
            case "偶校验":
                i=2;
                break;
            case "标志位":
                i=3;
                break;
            case "空白位":
                i=4;
                break;
            default:
                i=0;
                break;
        }
        bean.setParity(i);
        return bean;
    }

    private SerialModemBean getModemData(){
        SerialModemBean serialModemBean=new SerialModemBean();
        serialModemBean.setFlow(flow.isChecked());
        serialModemBean.setDTR(cbDTR.isChecked()? 1:0);
        serialModemBean.setRTS(cbRTS.isChecked()? 1:0);
        return serialModemBean;
    }

    //当流控开启时，禁用RTS
    public void updateRSTStatus(boolean flow){
        handler.post(new Runnable() {
            @Override
            public void run() {
                cbRTS.setEnabled(!flow);
            }
        });
    }
}
