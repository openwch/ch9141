package cn.wch.ch9140uart.ui;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import cn.wch.ch9140uart.MyApplication;
import cn.wch.ch9140uart.R;
import cn.wch.ch9140uart.storage.ConfigSaveUtil;
import cn.wch.ch9140uart.storage.SendBean;
import cn.wch.ch9140uart.task.SendType;


public class SendConfigDialog extends DialogFragment {

    private final SendBean sendBean;

    private Button confirm;
    private Button cancel;
    private RadioButton single;
    private RadioButton timing;
    private RadioButton cyclic;
    private RadioButton file;
    private EditText interval;
    private Button chooseFile;
    private TextView path;
    private LinearLayout llInterval;
    private LinearLayout llChooseFile;

    private File dstFile;

    private Handler handler=new Handler(Looper.getMainLooper());
    private OnClickListener listener;


    public static SendConfigDialog newInstance(SendBean bean) {
        Bundle args = new Bundle();
        SendConfigDialog fragment = new SendConfigDialog(bean);
        fragment.setArguments(args);
        return fragment;
    }

    public SendConfigDialog(SendBean sendBean) {
        this.sendBean = sendBean;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.dialog_send_config, null);
        init(view);
        return view;
    }

    private void init(View view) {
        confirm=view.findViewById(R.id.confirm);
        cancel=view.findViewById(R.id.cancel);

        single=view.findViewById(R.id.radio_single_send);
        timing=view.findViewById(R.id.radio_timing_send);
        cyclic=view.findViewById(R.id.radio_continuing_send);
        file=view.findViewById(R.id.radio_file_send);

        interval=view.findViewById(R.id.send_interval);
        chooseFile=view.findViewById(R.id.choose_file);
        path=view.findViewById(R.id.filePath);

        llInterval=view.findViewById(R.id.ll_interval);
        llChooseFile=view.findViewById(R.id.ll_choose_file);



        if(sendBean!=null){
            if(sendBean.getType()== SendType.TYPE_SINGLE){
                single.setChecked(true);
                llInterval.setVisibility(View.GONE);
                llChooseFile.setVisibility(View.GONE);
            }else if(sendBean.getType()== SendType.TYPE_TIMING){
                timing.setChecked(true);
                llInterval.setVisibility(View.VISIBLE);
                llChooseFile.setVisibility(View.GONE);
            }else if(sendBean.getType()== SendType.TYPE_CYCLIC){
                cyclic.setChecked(true);
                llInterval.setVisibility(View.GONE);
                llChooseFile.setVisibility(View.GONE);
            }else if(sendBean.getType()== SendType.TYPE_FILE){
                file.setChecked(true);
                llInterval.setVisibility(View.GONE);
                llChooseFile.setVisibility(View.VISIBLE);
            }
            interval.setText(sendBean.getInterval()+"");
            if(sendBean.getFile()!=null){
                path.setText(sendBean.getFile().getName());
            }
            dstFile=sendBean.getFile();
        }


        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                clickConfirm();
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        single.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    llInterval.setVisibility(View.GONE);
                    llChooseFile.setVisibility(View.GONE);
                }
            }
        });
        timing.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    llInterval.setVisibility(View.VISIBLE);
                    llChooseFile.setVisibility(View.GONE);
                }
            }
        });
        cyclic.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    llInterval.setVisibility(View.GONE);
                    llChooseFile.setVisibility(View.GONE);
                }
            }
        });
        file.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    llInterval.setVisibility(View.GONE);
                    llChooseFile.setVisibility(View.VISIBLE);
                }
            }
        });
        chooseFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(listener!=null){
                    listener.onChooseFile();
                }

            }
        });
    }

    public void setOnClickListener(OnClickListener listener){
        this.listener=listener;
    }

    public void setFileResult(File file){
        dstFile=file;
        path.setText(file.getName());
    }

    private void clickConfirm() {
        SendBean sendBean=null;
        if(single.isChecked()){
            sendBean=new SendBean(SendType.TYPE_SINGLE);
        }else if(timing.isChecked()){
            String i=interval.getText().toString();
            if(TextUtils.isEmpty(i)){
                showToast("请填写间隔时间");
                return;
            }
            long l=Long.parseLong(i);
            sendBean=new SendBean(SendType.TYPE_TIMING,l);
        }else if(cyclic.isChecked()){
            //循环发送，间隔时间为0
            sendBean=new SendBean(SendType.TYPE_CYCLIC,0);
        }else if(file.isChecked()){

            if(dstFile==null){
                showToast("请选择文件");
                return;
            }
            sendBean=new SendBean(SendType.TYPE_FILE,dstFile);
        }
        ConfigSaveUtil.getInstance().setSendBean(sendBean);
        showToast("下次发送开始生效");
        dismiss();
        if(listener!=null){
            listener.onConfirm();
        }

    }

    public static interface OnClickListener{
        void onChooseFile();
        void onConfirm();
    }

    private void showToast(String message){
        handler.post(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(MyApplication.getContext(),message,Toast.LENGTH_SHORT).show();
            }
        });
    }
}
