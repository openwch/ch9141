package cn.wch.ch9140uart;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothGatt;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;
import android.widget.Toast;

import com.tbruyelle.rxpermissions2.Permission;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.touchmcu.ui.DialogUtil;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import cn.wch.ch9140lib.CH9140BluetoothManager;
import cn.wch.ch9140lib.callback.CH9140MTUCallback;
import cn.wch.ch9140lib.callback.ConnectStatus;

import cn.wch.ch9140lib.exception.CH9140LibException;
import cn.wch.ch9140lib.utils.LogUtil;
import io.reactivex.functions.Consumer;

/**
 * 此抽象类适用与CH9141相关的通信
 */
public abstract class BLEBaseActivity extends AppCompatActivity {


    private RxPermissions rxPermissions;
    protected int REQUEST_BLUETOOTH_CODE=111;
    private Context context;

    protected  String address;

    protected  ScheduledExecutorService scheduledExecutorService;

    protected Runnable speedRunnable;
    protected boolean isHardwareOld=false;

    /**
     * 包括蓝牙相关通信权限和存储存储权限(Android 10及以上存储需特殊考虑)
     */
    String[] permissions=new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    };

    String[] permissions_ble=new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,

    };
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        setView();
        initWidget();
        init();
        initBle();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_BLUETOOTH_CODE && resultCode == RESULT_OK) {
            checkAutoStart();
        } else if (requestCode == REQUEST_BLUETOOTH_CODE) {
            showToast("请允许打开蓝牙");
        }else {
            onActivitySomeResult(requestCode, resultCode, data);
        }
    }





    protected boolean checkConnected(String address){

        return CH9140BluetoothManager.getInstance().isDeviceOpened(address);
    }
    protected void showDisconnectDialog() {

        DialogUtil.getInstance().showDisconnectDialog(this,new DialogUtil.IDisconnectResult() {
            @Override
            public void onDisconnect() {
                try {
                    CH9140BluetoothManager.getInstance().closeDevice(address,false);
                } catch (CH9140LibException e) {
                    e.printStackTrace();
                    LogUtil.d(e.getMessage());
                }
            }

            @Override
            public void onCancel() {

            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }



    protected  void init(){
        context=this;
        rxPermissions=new RxPermissions(this);
    }


    public void requestPermission(){
        rxPermissions.requestEachCombined(permissions).subscribe(new Consumer<Permission>() {
            @Override
            public void accept(Permission permission) throws Exception {
                if (permission.granted) {//全部同意后调用
                    openBlueAdapter();
                } else if (permission.shouldShowRequestPermissionRationale) {//只要有一个选择：禁止，但没有选择“以后不再询问”，以后申请权限，会继续弹出提示
                    showToast("请允许权限,否则APP不能正常运行");
                } else {//只要有一个选择：禁止，但选择“以后不再询问”，以后申请权限，不会继续弹出提示
                    showToast("请到设置中打开权限");
                }
            }
        });
    }



    private void  initBle(){
        if (!isSupportBle(this)) {
            showToast("本设备不支持BLE");
            System.exit(0);
            return;
        }
        requestPermission();
    }

    private void openBlueAdapter(){
        if (BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            //执行操作
            checkAutoStart();
        } else {
            //未打开蓝牙
            Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(intent, REQUEST_BLUETOOTH_CODE);
        }
    }

    /**
     * 在一些应用中需要在开始时扫描，那么就需要检查是否满足必要的条件
     */
    private void checkAutoStart(){
        //Adapter
        if(!BluetoothAdapter.getDefaultAdapter().isEnabled()){
            LogUtil.d("Adapter is closed, deny auto start");
            return;
        }
        //permission
        for (String permission : permissions_ble) {
            if(ActivityCompat.checkSelfPermission(this,permission)!=PackageManager.PERMISSION_GRANTED){
                LogUtil.d("permission is deny, deny auto start");
                return;
            }
        }

        startTask();
    }

    /**
     * 蓝牙服务绑定后需要执行的操作
     */
    protected void startTask(){

    }

    public static boolean isSupportBle(Context context){
        PackageManager packageManager=context.getPackageManager();
        return BluetoothAdapter.getDefaultAdapter()!=null && packageManager!=null && packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE);
    }


    void showToast(final String message){
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(context,message,Toast.LENGTH_SHORT).show();
            }
        });
    }

    /////////////////////////////////////connect///////////////////////////////////////////
    protected void connectBLE(String mac) {
        try {
            CH9140BluetoothManager.getInstance().openDevice(mac,10000,connectStatus);
        } catch (CH9140LibException e) {
            e.printStackTrace();
            LogUtil.d(e.getMessage());
        }
    }

    private ConnectStatus connectStatus=new ConnectStatus() {
        @Override
        public void OnError(Throwable t) {
            LogUtil.d("连接回调："+t.getMessage());
            onConnectError(t.getMessage());
            showToast(t.getMessage());
        }

        @Override
        public void OnConnecting() {
            isHardwareOld=false;
            onConnecting();
        }

        @Override
        public void OnConnectSuccess(String mac) {
            address=mac;
            showToast("蓝牙连接成功");
            onConnectSuccess();
            setSpeedMonitor();

        }

        @Override
        public void onInvalidDevice(String mac) {
            showToast("该蓝牙设备不是CH9141");
            try {
                CH9140BluetoothManager.getInstance().closeDevice(mac,false);
            } catch (CH9140LibException e) {
                e.printStackTrace();
            }
            onConnectError("该蓝牙设备不是CH9141");
        }

        @Override
        public void OnConnectTimeout(String mac) {
            //hideLoadingDialog();
            showToast("连接超时");
            onConnectError("连接超时");
        }

        @Override
        public void OnDisconnect(String mac,int status) {
            LogUtil.d("连接回调：断开连接");
            cancelSpeedMonitor();
            showToast("蓝牙断开连接");
            onDisconnect();
        }

        @Override
        public void onSerialReadData(byte[] data) {
            onSerialData(data);
        }
    };




    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    protected void setMtu(int mtu){
        try {
            CH9140BluetoothManager.getInstance().setMTU(mtu, new CH9140MTUCallback() {
                @Override
                public void onMTUChanged(BluetoothGatt gatt, int mtu, int status) {
                    if(status== BluetoothGatt.GATT_SUCCESS){
                        LogUtil.d("MTU大小设置为"+mtu);
                        showToast("MTU大小设置为"+mtu);
                    }else {
                        LogUtil.d("设置MTU大小失败");
                        showToast("设置MTU大小失败");
                    }
                }
            });
        } catch (CH9140LibException e) {
            e.printStackTrace();
            LogUtil.d(e.getMessage());
        }
    }


    /**
     * 监控和收发速度
     */
    private void setSpeedMonitor(){
        if(speedRunnable==null){
            LogUtil.d("speed monitor is null");
            return;
        }
        cancelSpeedMonitor();
        scheduledExecutorService= Executors.newScheduledThreadPool(2);
        scheduledExecutorService.scheduleWithFixedDelay(speedRunnable,100,1000, TimeUnit.MILLISECONDS);
    }

    private void cancelSpeedMonitor(){
        if(scheduledExecutorService!=null){
            scheduledExecutorService.shutdown();
            scheduledExecutorService=null;
        }
    }

    /**
     * 用来监测收发速度，定时器每秒触发，执行操作
     * @param runnable 需要执行的操作
     */
    protected void setScheduleSpeedMonitor(@NonNull Runnable runnable){
        this.speedRunnable=runnable;
    }

    protected boolean checkValid(){
        return CH9140BluetoothManager.getInstance().isDeviceOpened(address);
    }


    protected abstract void setView();
    protected abstract void initWidget();
    protected abstract void onActivitySomeResult(int requestCode, int resultCode, @Nullable Intent data);
    protected abstract void onConnecting();
    protected abstract void onConnectSuccess();
    protected abstract void onConnectError(String message);
    protected abstract void onDisconnect();
    protected abstract void onSerialData(byte[] data);

}

