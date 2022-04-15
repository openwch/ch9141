package cn.wch.ch9140uart.ui;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.widget.Toast;

import com.suke.widget.SwitchButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import cn.wch.ch9140uart.MyApplication;
import cn.wch.ch9140uart.R;

public class SendInterruptConfigDialog extends DialogFragment {


    private Button confirm;
    private Button cancel;
    private SwitchButton interrupt;
    private boolean status;
    private Handler handler=new Handler(Looper.getMainLooper());

    public static SendInterruptConfigDialog newInstance(boolean status) {
        Bundle args = new Bundle();
        SendInterruptConfigDialog fragment = new SendInterruptConfigDialog(status);
        fragment.setArguments(args);
        return fragment;
    }

    public SendInterruptConfigDialog(boolean status) {
        this.status = status;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.dialog_interrupt, null);
        init(view);
        return view;
    }

    private void init(View view) {
        confirm=view.findViewById(R.id.confirm);
        cancel=view.findViewById(R.id.cancel);
        interrupt=view.findViewById(R.id.interrupt);

        interrupt.setChecked(status);


        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //CH9140BluetoothManager.getInstance().setBluetoothFlow(interrupt.isChecked());
                dismiss();
            }
        });
        interrupt.setOnCheckedChangeListener(new SwitchButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(SwitchButton view, boolean isChecked) {

            }
        });
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
