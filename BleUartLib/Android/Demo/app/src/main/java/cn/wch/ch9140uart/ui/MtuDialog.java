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
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import cn.wch.ch9140uart.R;

public class MtuDialog extends DialogFragment {

    private Button mCancel;
    private Button mConfirm;
    private TextView text;
    private Handler handler=new Handler(Looper.getMainLooper());
    private ClickListener listener;

    public static MtuDialog newInstance() {
        Bundle args = new Bundle();
        MtuDialog fragment = new MtuDialog();
        fragment.setArguments(args);
        return fragment;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.dialog_mtu, null);
        init(view);
        return view;
    }

    private void init(View view) {
        mCancel=view.findViewById(R.id.cancel);
        mConfirm=view.findViewById(R.id.confirm);
        text=view.findViewById(R.id.mtu);
        mCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
            }
        });
        mConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirm();
            }
        });
    }

    public static interface ClickListener{
        void onResult(int mtu);
    }

    public void setListener(ClickListener listener){
        this.listener=listener;
    }

    private void confirm(){
        if(TextUtils.isEmpty(text.getText())){
            showToast("MTU值为空");
            return;
        }
        if(!checkMtuSizeValid(text.getText().toString())){
            showToast("请填写合适的MTU值");
            return;
        }
        if(listener!=null){
            listener.onResult(Integer.parseInt(text.getText().toString()));
        }
        dismiss();
    }

    private void cancel(){
        dismiss();
    }

    private boolean checkMtuSizeValid(String mtu){
        if(TextUtils.isEmpty(mtu)){
            return false;
        }
        int i = Integer.parseInt(mtu);
        return i>=23 && i<=247;
    }

    private void showToast(String message){
        handler.post(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(getActivity(),message,Toast.LENGTH_SHORT).show();
            }
        });
    }
}
