package cn.wch.ch9140uart.ui;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import cn.wch.ch9140uart.R;

public class DeviceAdapter extends RecyclerView.Adapter<DeviceAdapter.MyHolderView> {

    private LayoutInflater inflater;
    private List<BluetoothDevice> deviceList;
    private Map<String, Integer> rssiMap;
    private Map<String, Integer> imageMap;
    private onClickListener onClickListener;

    public DeviceAdapter(Context context,onClickListener onClickListener) {
        inflater=LayoutInflater.from(context);
        deviceList=new ArrayList<>();
        rssiMap=new HashMap<>();
        imageMap=new HashMap<>();
        this.onClickListener=onClickListener;
    }

    @NonNull
    @Override
    public DeviceAdapter.MyHolderView onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new MyHolderView(inflater.inflate(R.layout.dialog_devicelist_item,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull DeviceAdapter.MyHolderView holder, int position) {
        BluetoothDevice device = deviceList.get(position);
        holder.name.setText(device.getName()==null ? "null":device.getName());
        holder.mac.setText(device.getAddress());
        //holder.name.setText(device.getName()==null ? "N/A" : device.getName());
        //storage
        /*Integer integer = imageMap.get(device.getAddress());
        //current
        int image = getImage(rssiMap.get(device.getAddress()));
        if(integer==null || image!=integer){
            LogUtil.d("加载图片");
            imageMap.put(device.getAddress(),image);

            //holder.indicator.setImageResource(image);
        }*/
        holder.indicator.getDrawable().setLevel(Math.abs(rssiMap.get(device.getAddress())));

        holder.rssi.setText(rssiMap==null ? "Null" : rssiMap.get(device.getAddress())+" dBm");
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(onClickListener!=null){
                    onClickListener.onClick(device);
                }
            }
        });
    }

    @Override
    public void onBindViewHolder(@NonNull MyHolderView holder, int position, @NonNull List<Object> payloads) {
        if(payloads.isEmpty()){
            onBindViewHolder(holder,position);
        }else{
            MyHolderView myViewHolder=(MyHolderView)holder;
            if(payloads.get(0)!=null) {
                if(payloads.get(0) instanceof RSSIMSG){
                    RSSIMSG msg= (RSSIMSG) payloads.get(0);
                    myViewHolder.rssi.setText(msg.getRssi()+" dBm");
                    myViewHolder.indicator.getDrawable().setLevel(Math.abs(msg.getRssi()));

                }

            }

        }
    }

    @Override
    public int getItemCount() {
        return deviceList.size();
    }

    public void update(BluetoothDevice device,int rssi){
        if(deviceList==null){
            return;
        }
        for (int i=0;i<deviceList.size();i++) {
            BluetoothDevice bluetoothDevice=deviceList.get(i);
            if(bluetoothDevice.getAddress().equalsIgnoreCase(device.getAddress())){
                //更新rssi值
                rssiMap.put(device.getAddress(),rssi);
                notifyItemChanged(i,new RSSIMSG(bluetoothDevice.getAddress(),rssi));
                return;
            }
        }
        deviceList.add(device);
        rssiMap.put(device.getAddress(),rssi);
        notifyItemInserted(getItemCount());
    }

    public static class MyHolderView extends RecyclerView.ViewHolder{
        TextView name;
        TextView rssi;
        TextView mac;
        ImageView indicator;
        public MyHolderView(@NonNull View itemView) {
            super(itemView);
            rssi = itemView.findViewById(R.id.rssi);
            mac = itemView.findViewById(R.id.mac);
            name = itemView.findViewById(R.id.name);
            indicator = itemView.findViewById(R.id.indicator);
        }
    }

    public interface onClickListener{
        void onClick(BluetoothDevice device);
    }

    private @DrawableRes int getImage(int rssi){
        if(rssi<-100){
            return R.drawable.ic_sign_0;
        }else if(rssi<-80){
            return R.drawable.ic_sign_1;
        }else if(rssi<-60){
            return R.drawable.ic_sign_2;
        }else if(rssi<-40){
            return R.drawable.ic_sign_3;
        }else if(rssi<-20){
            return R.drawable.ic_sign_4;
        }else {
            return R.drawable.ic_sign_5;
        }
    }

    public class RSSIMSG{
        String address;
        int rssi;

        public RSSIMSG(String address, int rssi) {
            this.address = address;
            this.rssi = rssi;
        }

        public int getRssi() {
            return rssi;
        }

        public void setRssi(int rssi) {
            this.rssi = rssi;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }
    }

    public class Indicator{

    }

    public class UpdateMsg{
        int rssi;
        int imgId;

        public UpdateMsg(int rssi, int imgId) {
            this.rssi = rssi;
            this.imgId = imgId;
        }

        public int getRssi() {
            return rssi;
        }

        public void setRssi(int rssi) {
            this.rssi = rssi;
        }

        public int getImgId() {
            return imgId;
        }

        public void setImgId(int imgId) {
            this.imgId = imgId;
        }
    }
}
