package cn.wch.ch9140uart.ui;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import cn.wch.ch9140uart.MyApplication;
import cn.wch.ch9140uart.R;


public class DeviceListDialog extends DialogFragment {

    private RecyclerView recyclerView;
    private DeviceAdapter adapter;
    private Context context;
    private Button cancel;
    private OnClick onClick;

    public static DeviceListDialog newInstance() {
        Bundle args = new Bundle();
        DeviceListDialog fragment = new DeviceListDialog();
        fragment.setArguments(args);
        return fragment;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = inflater.inflate(R.layout.dialog_devicelist, null);
        init(view);
        return view;
    }

    private void init(View view) {
        context= MyApplication.getContext();
        recyclerView=view.findViewById(R.id.list);
        adapter=new DeviceAdapter(context, new DeviceAdapter.onClickListener() {
            @Override
            public void onClick(BluetoothDevice device) {
                closeDialog();
                if(onClick!=null){
                    onClick.onClick(device.getAddress());
                }

            }
        });
        recyclerView.setLayoutManager(new LinearLayoutManager(context,LinearLayoutManager.VERTICAL,false));
        recyclerView.setAdapter(adapter);
        DividerItemDecoration decoration=new DividerItemDecoration(context,DividerItemDecoration.VERTICAL);
        recyclerView.addItemDecoration(decoration);

        cancel=view.findViewById(R.id.cancel);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                closeDialog();
            }
        });

    }

    public void setOnClickListener(OnClick onClickListener){
        onClick=onClickListener;
    }

    public void update(BluetoothDevice device,int rssi){
        if(adapter!=null){
            adapter.update(device,rssi);
        }
    }

    private void closeDialog(){
        if(onClick!=null){
            onClick.onCancel();
        }
        dismiss();
    }
    public static interface OnClick{
        void onClick(String mac);
        void onCancel();
    }
}
