package cn.wch.blecommon;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import cn.wch.blecommon.constant.StringConstant;
import cn.wch.blecommon.ui.DeviceListDialog;
import cn.wch.blecommon.ui.MtuDialog;
import cn.wch.blelib.WCHBluetoothManager;
import cn.wch.blelib.exception.BLELibException;
import cn.wch.blelib.host.core.callback.NotifyDataCallback;
import cn.wch.blelib.host.scan.ScanObserver;
import cn.wch.blelib.host.scan.ScanRuler;
import cn.wch.blelib.utils.FormatUtil;
import cn.wch.blelib.utils.Location;
import cn.wch.blelib.utils.LogUtil;
import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.Observer;
import io.reactivex.Scheduler;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.text.method.ScrollingMovementMethod;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import com.suke.widget.SwitchButton;
import com.touchmcu.ui.DialogUtil;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

public class MainActivity extends BLEBaseActivity {

    private DeviceListDialog deviceListDialog;
    private List<BluetoothGattService> serviceList;
    private boolean isConnected = false;

    private Spinner spService;
    private Spinner spCharacteristic;


    private TextView tvReceiveCount;
    private SwitchButton sbReceiveHex;
    private SwitchButton sbNotify;
    private TextView tvReceive;
    private Button btnClearReceive;
    private Button btnRead;

    private TextView tvSendCount;
    private SwitchButton sbSendHex;
    private EditText etSend;
    private Button btnClearSend;
    private Button btnSend;

    private Button btnTest;
    private int count_R=0;
    private int count_W=0;
    private Handler handler=new Handler(Looper.getMainLooper());

    private BluetoothGattCharacteristic currentCharacteristic;

    private TextView notifyLabel;

    @Override
    protected void setView() {
        setContentView(R.layout.activity_main);
    }

    @Override
    protected void initWidget() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        spService=findViewById(R.id.sp_service);
        spCharacteristic=findViewById(R.id.sp_characteristic);

        tvReceiveCount=findViewById(R.id.receive_count);
        sbReceiveHex=findViewById(R.id.receive_hex);
        sbNotify=findViewById(R.id.char_details_notification_switcher);
        tvReceive=findViewById(R.id.receive_data);
        btnClearReceive=findViewById(R.id.clear_receive);
        btnRead=findViewById(R.id.btn_read);

        tvSendCount=findViewById(R.id.send_count);
        sbSendHex=findViewById(R.id.send_hex);
        etSend=findViewById(R.id.send_data);
        btnClearSend=findViewById(R.id.clear_write);
        btnSend=findViewById(R.id.write);

        btnTest=findViewById(R.id.btn_test);
        notifyLabel=findViewById(R.id.tv_notify_label);

        btnTest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(btnTest.getText().toString().equalsIgnoreCase(StringConstant.BTN_TEST_START)){
                    startTest();
                    btnTest.setText(StringConstant.BTN_TEST_STOP);
                }else if(btnTest.getText().toString().equalsIgnoreCase(StringConstant.BTN_TEST_STOP)){
                    stopTest();
                    btnTest.setText(StringConstant.BTN_TEST_START);
                }
            }
        });

        sbNotify.setEnabled(false);
    }

    @Override
    protected void onActivitySomeResult(int requestCode, int resultCode, @Nullable Intent data) {

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        LogUtil.d("------------------------");
        getMenuInflater().inflate(R.menu.menu_main, menu);

        menu.findItem(R.id.ble_connect).setVisible( !isConnected);
        menu.findItem(R.id.ble_disconnect).setVisible(isConnected);
        menu.findItem(R.id.ble_set_mtu).setVisible(isConnected);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ble_connect) {
            startScan();
        } else if (itemId == R.id.ble_disconnect) {
            try {
                WCHBluetoothManager.getInstance().disconnect(false);
            } catch (BLELibException e) {
                e.printStackTrace();
            }
        } else if (itemId == R.id.ble_set_mtu) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                setMtu();
            } else {
                showToast("当前安卓版本的手机不支持设置mtu");
            }
        }else if (itemId == R.id.copyright) {
            DialogUtil.getInstance().showSimpleDialog(MainActivity.this, getResources().getString(R.string.copyright), "了解", new DialogUtil.IResult() {
                @Override
                public void onContinue() {

                }

                @Override
                public void onCancel() {

                }
            });
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        if (checkConnected(address)) {
            showDisconnectDialog();
            return;
        }
        super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        try {
            WCHBluetoothManager.getInstance().disconnect(true);
        } catch (BLELibException e) {
            e.printStackTrace();
        }
        super.onDestroy();
    }

    @Override
    protected void startTask() {
        super.startTask();
        startScan();
    }

    @Override
    protected void onConnecting() {
        isConnected = false;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                DialogUtil.getInstance().showLoadingDialog(MainActivity.this, "正在连接...");
            }
        });
    }
    @Override
    protected void onConnectSuccess() {
        //LogUtil.d("onConnectSuccess: "+serviceList.size());
        //连接成功，随后进行枚举服务
    }

    @Override
    protected void onDiscoverService(List<BluetoothGattService> services) {
        LogUtil.d("onDiscoverService: "+services.size());
        serviceList=services;
        isConnected = true;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                isConnected = true;
                DialogUtil.getInstance().hideLoadingDialog();
                reDraw();

                initServiceSpinner(serviceList);
                enableWidget(true);

            }
        });
    }



    @Override
    protected void onConnectError(String message) {
        isConnected = false;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {

                DialogUtil.getInstance().hideLoadingDialog();
            }
        });
    }

    @Override
    protected void onDisconnect() {
        isConnected = false;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                reDraw();
                enableWidget(false);
                enableButtons(false);
                DialogUtil.getInstance().hideLoadingDialog();
                resetWidget();
                stopCurrentChar();
            }
        });
    }

    private void startScan() {
        //init transitionRunnable

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            //大于安卓10，需要检查定位服务
            LogUtil.d("位置服务打开：" + Location.isLocationEnable(this));
            if (!Location.isLocationEnable(this)) {
                DialogUtil.getInstance().showSimpleDialog(this, "蓝牙扫描需要开启位置信息服务", new DialogUtil.IResult() {
                    @Override
                    public void onContinue() {
                        Location.requestLocationService(MainActivity.this);
                    }

                    @Override
                    public void onCancel() {

                    }
                });

                return;
            }
        }

        if (!checkBtEnabled()) {
            showToast("请先打开蓝牙");
            return;
        }

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            showToast("定位权限未开启");
            return;
        }
        try {
            WCHBluetoothManager.getInstance().startScan(null,scanObserver);
            //WCHBluetoothManager.getInstance().startScanCH914X(scanObserver);
        } catch (BLELibException e) {
            e.printStackTrace();
        }
        showDeviceList();
    }

    private ScanObserver scanObserver=new ScanObserver() {
        @Override
        public void OnScanDevice(BluetoothDevice device, int rssi, byte[] broadcastRecord) {
            String mac = device.getAddress();

            //update device list
            if (deviceListDialog != null && deviceListDialog.isVisible()) {
                deviceListDialog.update(device, rssi);
                return;
            }
            //unknown status
            //LogUtil.d("unknown status");
        }
    };

    private void stopScan() {
        LogUtil.d("停止扫描");
        WCHBluetoothManager.getInstance().stopScan();
    }

    private void showDeviceList() {
        //展示设备列表并且更新信息
        deviceListDialog = DeviceListDialog.newInstance();
        deviceListDialog.setCancelable(false);
        deviceListDialog.show(getSupportFragmentManager(), "DeviceList");
        deviceListDialog.setOnClickListener(new DeviceListDialog.OnClick() {
            @Override
            public void onClick(String mac) {
                connectBLE(mac);
            }

            @Override
            public void onCancel() {
                stopScan();
            }
        });
    }


    private boolean checkBtEnabled() {
        boolean enabled = BluetoothAdapter.getDefaultAdapter().isEnabled();
        if (!enabled) {
            Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(intent, REQUEST_BLUETOOTH_CODE);
        }
        return enabled;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    void setMtu() {

        MtuDialog dialog = MtuDialog.newInstance();
        dialog.setCancelable(false);
        dialog.show(getSupportFragmentManager(), "Mtu");
        dialog.setListener(new MtuDialog.ClickListener() {
            @Override
            public void onResult(int mtu) {
                setMtu(mtu);
            }
        });
    }

    void initServiceSpinner(List<BluetoothGattService> services){
        if(services==null || services.size()==0){
            showToast("服务列表为空");
            //deviceList = new BluetoothGattService[0];


            ArrayAdapter<String> adapter_5 = new ArrayAdapter<>(this, R.layout.item_spinner, new String[0]);
            adapter_5.setDropDownViewResource(R.layout.item_spinner);
            spService.setAdapter(adapter_5);
            spService.setGravity(0x10);
            spService.setSelection(0);
        }else {
            //deviceList=serviceList.toArray(new BluetoothGattService[0]);
            String[] serviceNames=new String[services.size()];
            for (int i = 0; i < services.size(); i++) {
                serviceNames[i]=services.get(i).getUuid().toString();
            }
            ArrayAdapter<String> adapter_5 = new ArrayAdapter<>(this, R.layout.item_spinner, serviceNames);
            adapter_5.setDropDownViewResource(R.layout.item_spinner);
            spService.setAdapter(adapter_5);
            spService.setOnItemSelectedListener(selectedListener);
            spService.setGravity(0x10);
            spService.setSelection(0);
        }

    }

    AdapterView.OnItemSelectedListener selectedListener=new AdapterView.OnItemSelectedListener() {
        @Override
        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            LogUtil.d("Spinner Service select "+position);
            if(serviceList!=null){
                initCharacteristic(serviceList.get(position));
            }
        }

        @Override
        public void onNothingSelected(AdapterView<?> parent) {

        }
    };


    void initCharacteristic(BluetoothGattService service){
        if(service==null){
            return;
        }
        List<BluetoothGattCharacteristic> characteristics = service.getCharacteristics();

        if(characteristics==null || characteristics.size()==0){
            String[] deviceList=new String[0];
            ArrayAdapter<String> adapter_5 = new ArrayAdapter<>(this, R.layout.item_spinner, deviceList);
            adapter_5.setDropDownViewResource(R.layout.item_spinner);
            spCharacteristic.setAdapter(adapter_5);
            spCharacteristic.setGravity(0x10);
            spCharacteristic.setSelection(0);

        }else {

            String[] names=new String[characteristics.size()];
            for (int i = 0; i < characteristics.size(); i++) {
                names[i]=characteristics.get(i).getUuid().toString();
            }
            ArrayAdapter<String> adapter_5 = new ArrayAdapter<>(this, R.layout.item_spinner, names);
            adapter_5.setDropDownViewResource(R.layout.item_spinner);
            spCharacteristic.setAdapter(adapter_5);
            spCharacteristic.setGravity(0x10);
            spCharacteristic.setSelection(0);
        }


    }


    /**
     * 重绘
     */
    void reDraw() {
        invalidateOptionsMenu();
    }

    void resetWidget(){
        btnTest.setText(StringConstant.BTN_TEST_START);
        sbNotify.setEnabled(false);
    }

    void enableWidget(boolean enable){
        spService.setEnabled(enable);
        spCharacteristic.setEnabled(enable);
        btnTest.setEnabled(enable);

    }

    void enableButtons(boolean enable) {
        sbNotify.setEnabled(enable);
        btnClearReceive.setEnabled(enable);
        btnRead.setEnabled(enable);
        btnClearSend.setEnabled(enable);
        btnSend.setEnabled(enable);
    }

    void clearData(){
        count_R=0;
        count_W=0;
        tvReceiveCount.setText(String.format(Locale.getDefault(),"%d 字节",0));
        tvSendCount.setText(String.format(Locale.getDefault(),"%d 字节",0));
    }

    private void startTest(){
        tvReceive.setMovementMethod(ScrollingMovementMethod.getInstance());
        if(spService.getSelectedItem()==null || spCharacteristic.getSelectedItem()==null){
            showToast("Spinner未选中");
            return;
        }
        currentCharacteristic = getCurrentCharacteristic(spService.getSelectedItem().toString(), spCharacteristic.getSelectedItem().toString());
        if(currentCharacteristic==null){
            showToast("无法识别当前Characteristic");
            return;
        }

        spService.setEnabled(false);
        spCharacteristic.setEnabled(false);
        enableButtons(true);

        clearData();
        //隐藏一些控件
        sbNotify.setOnCheckedChangeListener(null);

        if((currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_NOTIFY)==0){
            //无通知属性
            sbNotify.setVisibility(View.INVISIBLE);
            notifyLabel.setVisibility(View.INVISIBLE);
        }else {
            sbNotify.setVisibility(View.VISIBLE);
            notifyLabel.setVisibility(View.VISIBLE);
            try {
                boolean notifyState = WCHBluetoothManager.getInstance().getNotifyState(currentCharacteristic);
                LogUtil.d("当前通知： "+notifyState);
                sbNotify.setChecked(notifyState);
                if(notifyState){
                    WCHBluetoothManager.getInstance().openNotify(currentCharacteristic,notifyDataCallback);
                }
                sbNotify.setOnCheckedChangeListener(new SwitchButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(SwitchButton view, boolean isChecked) {
                        enableNotify(currentCharacteristic,isChecked);

                    }
                });
            } catch (BLELibException e) {
                e.printStackTrace();
            }
        }
        if((currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_READ)==0){
            //无读属性
            btnRead.setEnabled(false);
            btnClearReceive.setEnabled(false);
        }else {
            btnRead.setEnabled(true);
            btnClearReceive.setEnabled(true);
        }
        if((currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_WRITE)==0
            || (currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE)==0){
            //无写属性
            btnSend.setEnabled(false);
            btnClearSend.setEnabled(false);
        }else {
            btnSend.setEnabled(true);
            btnClearSend.setEnabled(true);
            //写方式
            if((currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE)==0){
                currentCharacteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE);
            }
            if((currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_WRITE)==0){
                currentCharacteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT);
            }

        }


        btnClearReceive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                tvReceive.setText("");
                count_R=0;
                tvReceiveCount.setText(String.format(Locale.getDefault(),"%d 字节",count_R));
                tvReceive.scrollTo(0, 0);
            }
        });
        btnClearSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                etSend.setText("");
                count_W=0;
                tvSendCount.setText(String.format(Locale.getDefault(),"%d 字节",count_W));
            }
        });

        btnRead.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                read(currentCharacteristic);
            }
        });

        btnSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                writeData(currentCharacteristic);
            }
        });
    }

    private void stopTest(){
        spService.setEnabled(true);
        spCharacteristic.setEnabled(true);
        enableButtons(false);
        stopCurrentChar();
    }

    private void stopCurrentChar(){
        LogUtil.d("stop current char");
        if(currentCharacteristic==null){
            return;
        }
        sbNotify.setOnCheckedChangeListener(null);
        sbNotify.setChecked(false);
        if((currentCharacteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_NOTIFY)!=0){
            try {
                if(WCHBluetoothManager.getInstance().getNotifyState(currentCharacteristic)){
                    WCHBluetoothManager.getInstance().openNotify(currentCharacteristic,null);
                }
            } catch (BLELibException e) {
                e.printStackTrace();
                LogUtil.d(e.getMessage());
            }
        }
        currentCharacteristic=null;

    }

    private BluetoothGattCharacteristic getCurrentCharacteristic(String serviceUUID,String charUUID){
        UUID uuid1 = UUID.fromString(serviceUUID);
        UUID uuid2 = UUID.fromString(charUUID);

        for (BluetoothGattService service : serviceList) {
            if(service.getUuid().toString().equalsIgnoreCase(uuid1.toString())){
                return service.getCharacteristic(uuid2);
            }
        }
        return null;
    }

    NotifyDataCallback notifyDataCallback=new NotifyDataCallback() {
        @Override
        public void OnError(String mac, Throwable t) {
            LogUtil.d(t.getMessage());
        }

        @Override
        public void OnData(String mac, byte[] data) {
            updateValueTextView(data);
        }
    };

    private void updateValueTextView(final byte[] data) {
        if (data == null || data.length == 0) {
            return;
        }
        count_R += data.length;
        LogUtil.d("共接收到："+count_R);
        handler.post(new Runnable() {
            @Override
            public void run() {
                tvReceiveCount.setText(count_R + " 字节");
                if (tvReceive.getText().toString().length() >= 1500) {
                    tvReceive.setText("");
                    tvReceive.scrollTo(0, 0);
                }

                if (sbReceiveHex.isChecked()) {
                    tvReceive.append(FormatUtil.bytesToHexString(data));
                } else {
                    tvReceive.append(new String(data));
                }

                int offset = tvReceive.getLineCount() * tvReceive.getLineHeight();
                //int maxHeight = usbReadValue.getMaxHeight();
                int height = tvReceive.getHeight();
                //USBLog.d("offset: "+offset+"  maxHeight: "+maxHeight+" height: "+height);
                if (offset > height) {
                    //USBLog.d("scroll: "+(offset - usbReadValue.getHeight() + usbReadValue.getLineHeight()));
                    tvReceive.scrollTo(0, offset - tvReceive.getHeight() + tvReceive.getLineHeight());
                }
            }
        });

    }

    private void writeData(BluetoothGattCharacteristic characteristic){
        try {
            byte[] bytes=null;
            if (sbSendHex.isChecked()) {
                String s=etSend.getText().toString();
                if(!s.matches("([0-9|a-f|A-F]{2})*")){
                    showToast("发送内容不符合HEX规范");
                    return;
                }
                bytes = FormatUtil.hexStringToBytes(etSend.getText().toString());
            } else {
                bytes = etSend.getText().toString().getBytes("utf-8");
            }
            write(characteristic,bytes);
        }catch (Exception e){
            LogUtil.d(e.getMessage());
        }
    }

    private void write(BluetoothGattCharacteristic characteristic,byte[] data){
        Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@io.reactivex.annotations.NonNull ObservableEmitter<String> emitter) throws Exception {
                try {
                    int write = WCHBluetoothManager.getInstance().write(characteristic, data, data.length);
                    if(write<0){
                        emitter.onError(new Throwable("发送失败"));
                    }else if(write==data.length){
                        count_W+=write;
                        emitter.onComplete();
                    }else {
                        count_W+=write;
                        emitter.onComplete();
                    }

                }catch (BLELibException e){
                    emitter.onError(new Throwable(e.getMessage()));
                }

            }
        }).subscribeOn(Schedulers.single())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(@io.reactivex.annotations.NonNull Disposable d) {
                        btnSend.setEnabled(false);
                        btnSend.setText(StringConstant.BTN_STOP);

                    }

                    @Override
                    public void onNext(@io.reactivex.annotations.NonNull String s) {

                    }

                    @Override
                    public void onError(@io.reactivex.annotations.NonNull Throwable e) {
                        btnSend.setEnabled(true);
                        btnSend.setText(StringConstant.BTN_SEND);
                        showToast(e.getMessage());
                    }

                    @Override
                    public void onComplete() {
                        btnSend.setEnabled(true);
                        btnSend.setText(StringConstant.BTN_SEND);
                        tvSendCount.setText(String.format(Locale.getDefault(),"%d 字节",count_W));
                    }
                });
    }

    private void enableNotify(BluetoothGattCharacteristic characteristic,boolean enable){
        LogUtil.d("改变通知: "+enable);
        Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@io.reactivex.annotations.NonNull ObservableEmitter<String> emitter) throws Exception {

                try {
                    if(enable){
                        boolean b = WCHBluetoothManager.getInstance().openNotify(characteristic, notifyDataCallback);
                        if(!b){
                            emitter.onError(new Throwable("打开通知失败"));
                            return;
                        }
                    }else {
                        boolean b = WCHBluetoothManager.getInstance().closeNotify(characteristic);
                        if(!b){
                            emitter.onError(new Throwable("关闭通知失败"));
                            return;
                        }
                    }
                }catch (BLELibException e){
                    emitter.onError(new Throwable(e));
                    return;
                }

                emitter.onComplete();

            }
        }).subscribeOn(Schedulers.single())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(@io.reactivex.annotations.NonNull Disposable d) {
                        DialogUtil.getInstance().showLoadingDialog(MainActivity.this,"正在改变通知");
                    }

                    @Override
                    public void onNext(@io.reactivex.annotations.NonNull String s) {

                    }

                    @Override
                    public void onError(@io.reactivex.annotations.NonNull Throwable e) {
                        DialogUtil.getInstance().hideLoadingDialog();
                        showToast(e.getMessage());
                    }

                    @Override
                    public void onComplete() {
                        DialogUtil.getInstance().hideLoadingDialog();
                    }
                });
    }

    private void read(BluetoothGattCharacteristic characteristic){
        Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@io.reactivex.annotations.NonNull ObservableEmitter<String> emitter) throws Exception {
                try {
                    byte[] read = WCHBluetoothManager.getInstance().read(characteristic, true);

                    updateValueTextView(read);
                }catch (Exception e){
                    emitter.onError(new Throwable(e.getMessage()));
                }
                emitter.onComplete();

            }
        }).subscribeOn(Schedulers.single())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(@io.reactivex.annotations.NonNull Disposable d) {
                        btnRead.setEnabled(false);
                        DialogUtil.getInstance().showLoadingDialog(MainActivity.this,"正在读取");
                    }

                    @Override
                    public void onNext(@io.reactivex.annotations.NonNull String s) {

                    }

                    @Override
                    public void onError(@io.reactivex.annotations.NonNull Throwable e) {
                        btnRead.setEnabled(true);
                        DialogUtil.getInstance().hideLoadingDialog();
                    }

                    @Override
                    public void onComplete() {
                        btnRead.setEnabled(true);
                        DialogUtil.getInstance().hideLoadingDialog();
                    }
                });
    }


}