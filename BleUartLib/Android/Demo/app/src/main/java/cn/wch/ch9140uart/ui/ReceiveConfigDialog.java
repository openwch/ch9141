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
import android.widget.Toast;

import java.io.File;
import java.io.IOException;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.MyApplication;
import cn.wch.ch9140uart.R;
import cn.wch.ch9140uart.constant.Constant;
import cn.wch.ch9140uart.storage.ConfigSaveUtil;
import cn.wch.ch9140uart.storage.SaveBean;
import cn.wch.ch9140uart.storage.SaveType;

public class ReceiveConfigDialog  extends DialogFragment {

    private Button confirm;
    private Button cancel;
    private EditText fileName;
    private RadioButton saveFile;
    private RadioButton saveScreen;
    private RadioButton saveScreenNoClear;
    private RadioButton saveScreenPause;
    private LinearLayout input;

    private SaveBean saveBean;
    private OnResult result;
    private Bundle bundle;

    private Handler handler=new Handler(Looper.getMainLooper());

    public static ReceiveConfigDialog newInstance(SaveBean bean,Bundle bundle) {
        Bundle args = new Bundle();
        ReceiveConfigDialog fragment = new ReceiveConfigDialog(bean,bundle);
        fragment.setArguments(args);
        return fragment;
    }

    public ReceiveConfigDialog(SaveBean saveBean,Bundle bundle) {
        this.saveBean = saveBean;
        this.bundle=bundle;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.dialog_receive_config, null);
        init(view);
        return view;
    }

    private void init(View view) {
        confirm=view.findViewById(R.id.confirm);
        cancel=view.findViewById(R.id.cancel);
        fileName=view.findViewById(R.id.file_name);
        saveScreen=view.findViewById(R.id.radio_showScreen);
        saveScreenNoClear=view.findViewById(R.id.radio_showScreen_no_clear);
        saveScreenPause=view.findViewById(R.id.radio_showScreen_pause);
        saveFile=view.findViewById(R.id.radio_saveFile);
        input=view.findViewById(R.id.ll_save_input);

        if(saveBean!=null){
            saveScreen.setChecked(saveBean.getType()== SaveType.SHOW_SCREEN);
            saveScreenNoClear.setChecked(saveBean.getType()== SaveType.SHOW_SCREEN_NO_CLEAR);
            saveScreenPause.setChecked(saveBean.getType()== SaveType.SHOW_SCREEN_PAUSE);
            saveFile.setChecked(saveBean.getType()== SaveType.SAVE_FILE);
            fileName.setEnabled(saveBean.getType()== SaveType.SAVE_FILE);
            if(saveBean.getFile()!=null){
                //fileName.setText(getRightName(saveBean.getFile().getName()));
                //fileName.setText(getRightName(bundle));
            }
            input.setVisibility(saveBean.getType()== SaveType.SAVE_FILE? View.VISIBLE:View.GONE);
        }
        fileName.setText(getRightName(bundle));

        saveScreen.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    fileName.setEnabled(false);
                    input.setVisibility(View.GONE);
                }
            }
        });
        saveScreenNoClear.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    fileName.setEnabled(false);
                    input.setVisibility(View.GONE);
                }
            }
        });
        saveScreenPause.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    fileName.setEnabled(false);
                    input.setVisibility(View.GONE);
                }
            }
        });

        saveFile.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    fileName.setEnabled(true);
                    input.setVisibility(View.VISIBLE);
                }
            }
        });


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

    }

    private void clickConfirm(){
        //check
        if(saveScreen.isChecked()){
            //直接离开
            ConfigSaveUtil.getInstance().setSaveBean(new SaveBean(SaveType.SHOW_SCREEN));
            dismiss();

        }else if(saveScreenNoClear.isChecked()){
            //直接离开
            ConfigSaveUtil.getInstance().setSaveBean(new SaveBean(SaveType.SHOW_SCREEN_NO_CLEAR));
            dismiss();

        }else if(saveScreenPause.isChecked()){
            //直接离开
            ConfigSaveUtil.getInstance().setSaveBean(new SaveBean(SaveType.SHOW_SCREEN_PAUSE));
            dismiss();

        }else {
            //检查内容
            if(TextUtils.isEmpty(fileName.getText().toString())){
                showToast("文件名为空");
            }else {
                String path=fileName.getText().toString()+".log";
                File file = checkFileExist(path);
                ConfigSaveUtil.getInstance().setSaveBean(new SaveBean(SaveType.SAVE_FILE,file));
                dismiss();
                LogUtil.d("返回:"+file.getAbsolutePath());

            }
        }
        if(result!=null){
            result.onChanged();
        }
    }

    public void setOnListener(OnResult result){
        this.result=result;
    }

    private File checkFileExist(String fileName){
        File dir = MyApplication.getContext().getExternalFilesDir(Constant.Folder);
        File log=new File(dir,fileName);
        LogUtil.d(log.getAbsolutePath());
        if(!log.exists()){
            dir.mkdirs();
            try {
                log.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return log;
    }

    private void showToast(String message){
        handler.post(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(MyApplication.getContext(),message,Toast.LENGTH_SHORT).show();
            }
        });
    }

    public static interface OnResult{
        void onChanged();
    }

    /*public String getRightName(String name){
        Pattern pattern=Pattern.compile("(.*)\\.txt");
        Matcher matcher = pattern.matcher(name);
        while (matcher.find()){
            return matcher.group(1);
        }
        return "";
    }*/

    public String getRightName(Bundle bundle){
        if(bundle==null || bundle.getString(Constant.Bundle_Mac,null)==null){
            return "";
        }
        String mac=bundle.getString(Constant.Bundle_Mac,null);
        if(TextUtils.isEmpty(mac)){
            return "";
        }
        return cn.wch.ch9140uart.utils.FileUtil.getRandomName(mac);
    }



}
