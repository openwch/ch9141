package cn.wch.ch9140uart;

import android.Manifest;
import android.app.Dialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.text.method.ScrollingMovementMethod;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.leon.lfilepickerlibrary.LFilePicker;
import com.suke.widget.SwitchButton;
import com.touchmcu.ui.DialogUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Locale;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;
import cn.wch.ch9140lib.CH9140BluetoothManager;
import cn.wch.ch9140lib.callback.EnumResult;
import cn.wch.ch9140lib.callback.ModemStatus;
import cn.wch.ch9140lib.exception.CH9140LibException;
import cn.wch.ch9140lib.utils.AppUtil;
import cn.wch.ch9140lib.utils.FormatUtil;
import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.constant.Constant;
import cn.wch.ch9140uart.database.RoomUtil;
import cn.wch.ch9140uart.serial.ModemParse;
import cn.wch.ch9140uart.storage.ConfigSaveUtil;
import cn.wch.ch9140uart.storage.SaveBean;
import cn.wch.ch9140uart.storage.SaveType;
import cn.wch.ch9140uart.storage.SendBean;
import cn.wch.ch9140uart.storage.SerialBaudBean;
import cn.wch.ch9140uart.storage.SerialModemBean;
import cn.wch.ch9140uart.task.ATInterface;
import cn.wch.ch9140uart.task.BytesTaskBean;
import cn.wch.ch9140uart.task.FileTak;
import cn.wch.ch9140uart.task.FileTaskBean;
import cn.wch.ch9140uart.task.SendType;
import cn.wch.ch9140uart.task.SingleTask;
import cn.wch.ch9140uart.task.TimingTask;
import cn.wch.ch9140uart.ui.DeviceListDialog;
import cn.wch.ch9140uart.ui.MtuDialog;
import cn.wch.ch9140uart.ui.ReceiveConfigDialog;
import cn.wch.ch9140uart.ui.SendConfigDialog;
import cn.wch.ch9140uart.ui.SerialConfigDialog;
import cn.wch.ch9140uart.utils.FileUtil;
import cn.wch.ch9140uart.utils.Location;
import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

public class MainActivity extends BLEBaseActivity implements ATInterface {

    @BindView(R.id.write)
    Button write;

    @BindView(R.id.ll_send)
    LinearLayout llSend;

    Unbinder bind;
    @BindView(R.id.send_data)
    EditText sendData;
    @BindView(R.id.send_hex)
    SwitchButton sendHex;
    @BindView(R.id.send_speed)
    TextView sendSpeed;
    @BindView(R.id.clear_write)
    Button clearWrite;
    @BindView(R.id.send_count)
    TextView sendCount;
    @BindView(R.id.char_details_notification_switcher)
    SwitchButton charDetailsNotificationSwitcher;
    @BindView(R.id.receive_hex)
    SwitchButton receiveHex;
    @BindView(R.id.receive_data)
    TextView receiveData;
    @BindView(R.id.receive_count)
    TextView receiveCount;
    @BindView(R.id.receive_speed)
    TextView receiveSpeed;
    @BindView(R.id.clear_receive)
    Button clearReceive;
    @BindView(R.id.receive_set)
    Button receiveSet;
    @BindView(R.id.btn_set_serial)
    Button btnSetSerial;
    @BindView(R.id.read)
    Button read;
    @BindView(R.id.send_set)
    Button sendSet;
    @BindView(R.id.receive_desc)
    TextView receiveDesc;
    @BindView(R.id.receive_share)
    Button receiveShare;
    @BindView(R.id.ll_receive_save)
    LinearLayout llReceiveSave;
    @BindView(R.id.send_desc)
    TextView sendDesc;
    @BindView(R.id.progress)
    ProgressBar progress;
    @BindView(R.id.progress_value)
    TextView progressValue;
    @BindView(R.id.ll_progress)
    LinearLayout llProgress;
    @BindView(R.id.serial_info)
    TextView serialInfo;
    @BindView(R.id.receive_share_data)
    Button receiveShareData;
    @BindView(R.id.cb_dcd)
    CheckBox cbDcd;
    @BindView(R.id.cb_dsr)
    CheckBox cbDsr;
    @BindView(R.id.cb_cts)
    CheckBox cbCts;
    @BindView(R.id.cb_ri)
    CheckBox cbRi;
    @BindView(R.id.ll_content_serial)
    LinearLayout llContentSerial;

    private Handler handler = new Handler(Looper.getMainLooper());
    private boolean isConnected = false;
    private int CODE_CHOOSE_FILE = 110;

    private SerialConfigDialog dialog;
    private SaveType saveType=SaveType.SHOW_SCREEN;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        // TODO: add setContentView(...) invocation

    }

    @Override
    protected void setView() {
        setContentView(R.layout.activity_main);
        bind = ButterKnife.bind(this);
    }

    @Override
    protected void initWidget() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setScheduleSpeedMonitor(timeRunnable);
        initUi();
    }


    @Override
    protected void startTask() {
        startScan();
    }

    @Override
    protected void onActivitySomeResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (resultCode == RESULT_OK && requestCode == CODE_CHOOSE_FILE) {
            List<String> list = data.getStringArrayListExtra("paths");

            LogUtil.d(list.get(0));
            if (sendConfigDialog != null && sendConfigDialog.isVisible()) {
                sendConfigDialog.setFileResult(new File(list.get(0)));
            }
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);

        menu.findItem(R.id.ble_connect).setVisible( !isConnected);
        menu.findItem(R.id.ble_disconnect).setVisible(isConnected);
        menu.findItem(R.id.ble_set_mtu).setVisible(isConnected);
        menu.findItem(R.id.view_debug).setVisible(!isDebugModel());
        menu.findItem(R.id.view_monitor).setVisible(isDebugModel());

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ble_connect) {
            startScan();
        } else if (itemId == R.id.ble_disconnect) {
            try {
                CH9140BluetoothManager.getInstance().closeDevice(address,false);
            } catch (CH9140LibException e) {
                e.printStackTrace();
            }
        } else if (itemId == R.id.ble_set_mtu) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                setMtu();
            } else {
                showToast("当前安卓版本的手机不支持设置mtu");
            }
        } else if (itemId == R.id.view_debug) {
            setDebugModel();
        } else if (itemId == R.id.view_monitor) {
            setMonitorModel();
        }  else if (itemId == R.id.about) {
            toOfficialWebsite();
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
        closeReceive();
        try {
            CH9140BluetoothManager.getInstance().closeDevice(address,true);
        } catch (CH9140LibException e) {
            e.printStackTrace();
        }
        super.onDestroy();
        bind.unbind();
    }

    /************************************************scan**************************************************/
    //该时间用来扫描设备匹配数据库,自动连接
    private long transitionTime = 5000;
    private Runnable transitionRunnable;
    private DeviceListDialog deviceListDialog;

    private EnumResult enumResult=new EnumResult() {
        @Override
        public void onResult(BluetoothDevice device, int rssi, byte[] broadcastRecord) {
            String mac = device.getAddress();
            if(!isValidDevice(mac)){
                //LogUtil.d("该设备不是合法设备");
                return;
            }
            boolean favourite = isFavourite(mac);
            if (favourite) {
                //移除
                if (transitionRunnable != null) {
                    handler.removeCallbacks(transitionRunnable);
                    transitionRunnable = null;
                    stopScan();
                    connect(mac);
                    return;
                }
            }
            //update device list
            if (deviceListDialog != null && deviceListDialog.isVisible()) {
                deviceListDialog.update(device, rssi);
                return;
            }
            //unknown status
            //LogUtil.d("unknown status");
        }
    };

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

        if (transitionRunnable != null) {
            handler.removeCallbacks(transitionRunnable);
            transitionRunnable = null;
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
            CH9140BluetoothManager.getInstance().startEnumDevices(enumResult);
        } catch (CH9140LibException e) {
            e.printStackTrace();
        }

        if (isDatabaseEmpty() || !TextUtils.isEmpty(address)) {
            LogUtil.d("Database is empty or app has connect one device before reconnect,directly show device list");
            showDeviceList();
        } else {
            transitionRunnable = new Runnable() {
                @Override
                public void run() {

                    DialogUtil.getInstance().hideLoadingDialog();
                    showDeviceList();
                    transitionRunnable = null;
                }
            };
            handler.postDelayed(transitionRunnable, transitionTime);
            DialogUtil.getInstance().showLoadingDialog(this, "正在扫描");
        }


    }

    private void stopScan() {
        LogUtil.d("停止扫描");
        try {
            CH9140BluetoothManager.getInstance().stopEnumDevices();
        } catch (CH9140LibException e) {
            e.printStackTrace();
        }
    }

    private void showDeviceList() {
        //展示设备列表并且更新信息
        deviceListDialog = DeviceListDialog.newInstance();
        deviceListDialog.setCancelable(false);
        deviceListDialog.show(getSupportFragmentManager(), "DeviceList");
        deviceListDialog.setOnClickListener(new DeviceListDialog.OnClick() {
            @Override
            public void onClick(String mac) {
                connect(mac);
            }

            @Override
            public void onCancel() {
                stopScan();
            }
        });
    }

    private boolean isDatabaseEmpty() {
        return RoomUtil.getInstance().isEmpty();
    }

    private boolean isValidDevice(String mac){
        if(mac==null){
            return false;
        }
        return true;
        //return mac.matches("84:[c|C]2:[e|E]4:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}");
    }

    private boolean isFavourite(String mac) {
        return RoomUtil.getInstance().isExistInDatabase(mac);
    }

    private boolean checkBtEnabled() {
        boolean enabled = BluetoothAdapter.getDefaultAdapter().isEnabled();
        if (!enabled) {
            Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(intent, REQUEST_BLUETOOTH_CODE);
        }
        return enabled;
    }


    /******************************************connect**********************************************/


    private void connect(String mac) {

        connectBLE(mac);
    }

    @Override
    protected void onConnecting() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                isConnected = false;
                DialogUtil.getInstance().showLoadingDialog(MainActivity.this, "正在连接...");
            }
        });

    }

    @Override
    protected void onConnectSuccess() {
        //hideNewFunctions(isHardwareOld);

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                isConnected = true;
                DialogUtil.getInstance().hideLoadingDialog();
                reDraw();
                enableButtons(true);
            }
        });
        //不支持旧版本固件
        try {
            isHardwareOld = !CH9140BluetoothManager.getInstance().isSupportedFirmware();
            if(isHardwareOld){
                LogUtil.d("旧版本固件，需要升级");
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        DialogUtil.getInstance().showSimpleDialog(MainActivity.this, getResources().getString(R.string.old_version),"知道了", new DialogUtil.IResult() {
                            @Override
                            public void onContinue() {
                                try {
                                    CH9140BluetoothManager.getInstance().closeDevice(address,false);
                                } catch (CH9140LibException e) {
                                    e.printStackTrace();
                                }
                            }

                            @Override
                            public void onCancel() {

                            }
                        });
                    }
                });
                return;
            }
        } catch (CH9140LibException e) {
            e.printStackTrace();
            return;
        }



        addToFavourite(address);
        initWriteData();
        initReadData();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            syncMtu();
        }
        initNotifyCallback();

        //如果是老版本硬件，不需要同步参数
        if(!isHardwareOld){
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    //清空状态
                    ConfigSaveUtil.getInstance().setSerialStatusBean(null);
                    syncSerialStatus(ConfigSaveUtil.getInstance().getSerialStatusBean().getSerialBaudBean(),
                            ConfigSaveUtil.getInstance().getSerialStatusBean().getSerialModemBean());
                }
            }, 700);
        }
    }

    @Override
    protected void onConnectError(String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                isConnected = false;
                DialogUtil.getInstance().hideLoadingDialog();
            }
        });
    }

    @Override
    protected void onDisconnect() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                isConnected = false;
                reDraw();
                enableButtons(false);
                DialogUtil.getInstance().hideLoadingDialog();
            }
        });

    }



    /**
     * 添加到数据库
     *
     * @param mac
     */
    private void addToFavourite(String mac) {
        if (BluetoothAdapter.checkBluetoothAddress(mac)) {
            RoomUtil.getInstance().add(mac);
        } else {
            LogUtil.d("invalid mac address");
        }

    }

    /********************************************ui************************************************/


    //如果连接到旧版的CH9141，需要隐藏部分新版本功能
    void hideNewFunctions(boolean isOld) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                //界面上串口以及Modem状态相关界面隐藏
                llContentSerial.setVisibility(isOld? View.GONE:View.VISIBLE);

            }
        });
    }

    /**
     * 重绘
     */
    void reDraw() {
        invalidateOptionsMenu();
    }

    /**
     *
     */
    boolean isDebugModel() {
        return llSend.getVisibility() == View.VISIBLE;
    }

    /**
     * 进入监听模式，隐藏发送区域
     */
    void setMonitorModel() {
        llSend.setVisibility(View.GONE);
        reDraw();
    }

    /**
     * 进入调试模式，显示送区域
     */
    void setDebugModel() {
        llSend.setVisibility(View.VISIBLE);
        reDraw();
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

    private void initUi() {

        receiveData.setMovementMethod(ScrollingMovementMethod.getInstance());
        write.setText(Constant.SEND);
        write.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!checkBtEnabled()) {
                    showToast("请先打开蓝牙");
                    return;
                }
                byte[] bytes = new byte[0];
                if (write.getText().toString().equalsIgnoreCase(Constant.SEND)) {
                    try {
                        if (sendHex.isChecked()) {
                            String s=sendData.getText().toString();
                            if(!s.matches("([0-9|a-f|A-F]{2})*")){
                                showToast("发送内容不符合HEX规范");
                                return;
                            }
                            bytes = FormatUtil.hexStringToBytes(sendData.getText().toString());
                        } else {
                            bytes = sendData.getText().toString().getBytes("utf-8");
                        }
                        //分析发送状态,默认是单次发送
                        SendBean sendStatus = ConfigSaveUtil.getInstance().getSendStatus();
                        if (sendStatus != null) {
                            if (sendStatus.getType() == SendType.TYPE_SINGLE) {
                                write(SendType.TYPE_SINGLE, bytes, 0);
                            } else if (sendStatus.getType() == SendType.TYPE_TIMING) {
                                write(SendType.TYPE_TIMING, bytes, sendStatus.getInterval());
                            } else if (sendStatus.getType() == SendType.TYPE_CYCLIC) {
                                write(SendType.TYPE_CYCLIC, bytes, sendStatus.getInterval());
                            } else if (sendStatus.getType() == SendType.TYPE_FILE) {
                                write(sendStatus.getFile());
                            }
                        } else {
                            write(SendType.TYPE_SINGLE, bytes, 0);
                        }


                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                } else if (write.getText().toString().equalsIgnoreCase(Constant.STOP)) {
                    cancel();
                }

            }
        });
        clearWrite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                clearWrite();
            }
        });
        clearReceive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                clearRead();
            }
        });

        receiveSet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putString(Constant.Bundle_Mac, address);
                ReceiveConfigDialog dialog = ReceiveConfigDialog.newInstance(ConfigSaveUtil.getInstance().getSaveStatus(), bundle);
                dialog.setCancelable(false);
                dialog.show(getSupportFragmentManager(), "ReceiveConfigDialog");

                dialog.setOnListener(new ReceiveConfigDialog.OnResult() {
                    @Override
                    public void onChanged() {
                        reModifySaveStatus();
                    }
                });
            }
        });
        receiveShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                share("分享功能需要独占文件，将切换至实时显示模式，是否继续？");
            }
        });
        receiveShareData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                shareData("分享功能将把屏幕上接收的数据保存至文件并分享，是否继续？");
            }
        });

        sendSet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendConfigDialog = SendConfigDialog.newInstance(ConfigSaveUtil.getInstance().getSendStatus());
                sendConfigDialog.setCancelable(false);
                sendConfigDialog.show(getSupportFragmentManager(), "SendConfigDialog");
                sendConfigDialog.setOnClickListener(new SendConfigDialog.OnClickListener() {
                    @Override
                    public void onChooseFile() {
                        pickFile();
                    }

                    @Override
                    public void onConfirm() {
                        reModifySendStatus();
                    }
                });
            }
        });

        btnSetSerial.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //SerialUtil.setBaudRate(myConnection, mConfig, 115200, 8, 1, 0);
                dialog = SerialConfigDialog.newInstance(ConfigSaveUtil.getInstance().getSerialStatusBean());
                dialog.setCancelable(false);
                dialog.show(getSupportFragmentManager(), "SerialConfigDialog");
                dialog.setListener(new SerialConfigDialog.onClickListener() {
                    @Override
                    public void onSetBaud(SerialBaudBean data) {
                        if (!checkBtEnabled()) {
                            showToast("请先打开蓝牙");
                            return;
                        }
                        setSerial(data);
                    }

                    @Override
                    public void onSetModem(SerialModemBean data) {
                        setModem( data);
                    }
                });
            }
        });
        read.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //只通过通知接收数据
            }
        });

    }

    /**
     * 根据连接状态，将按钮disable
     *
     * @param isConnected 蓝牙连接状态
     */
    void enableButtons(boolean isConnected) {
        btnSetSerial.setEnabled(isConnected);
        receiveSet.setEnabled(isConnected);
        read.setEnabled(isConnected);
        sendSet.setEnabled(isConnected);
        write.setEnabled(isConnected);
        clearReceive.setEnabled(isConnected);
        clearWrite.setEnabled(isConnected);
        receiveShareData.setEnabled(isConnected);
    }

    void updateModem(boolean DCD, boolean RI, boolean DSR, boolean CTS){
        handler.post(new Runnable() {
            @Override
            public void run() {
                cbDcd.setChecked(DCD);
                cbCts.setChecked(CTS);
                cbDsr.setChecked(DSR);
                cbRi.setChecked(RI);
            }
        });
    }

    void updateModem(byte[] data) {
        if (data == null || data.length != 7) {
            return;
        }
        handler.post(new Runnable() {
            @Override
            public void run() {
                LogUtil.d("更新modem状态");
                cbDcd.setChecked(ModemParse.isDCDValid(data[5]));
                cbCts.setChecked(ModemParse.isCTSValid(data[5]));
                cbDsr.setChecked(ModemParse.isDSRValid(data[5]));
                cbRi.setChecked(ModemParse.isRIValid(data[5]));
            }
        });
    }


    /***********************************************通信相关*************************************/
    //////////////////////////////////////////发送数据/////////////////////////

    private SingleTask singleTask;
    private FileTak fileTask;
    private TimingTask timingTask;

    private long count_W = 0;
    private long tempCount_W = 0;
    private long speed_W = 0;

    public volatile boolean flag = false;

    private SendConfigDialog sendConfigDialog;

    /**
     * 默认是单次发送
     */
    private SendType type = SendType.TYPE_SINGLE;

    /**
     * 定时器用来计数
     */
    private Runnable timeRunnable = new Runnable() {
        @Override
        public void run() {

            speed_R = count_R - tempCount_R;
            tempCount_R = count_R;
            speed_W = count_W - tempCount_W;
            tempCount_W = count_W;
            handler.post(new Runnable() {
                @Override
                public void run() {
                    if (sendSpeed != null) {
                        sendSpeed.setText(String.format(Locale.US, "%d 字节/秒", speed_W));
                    }
                    if (receiveSpeed != null) {
                        receiveSpeed.setText(String.format(Locale.US, "%d 字节/秒", speed_R));
                    }
                }
            });
        }
    };

    /**
     * 发送数据
     *
     * @param type
     * @param data
     */
    void write(SendType type, @NonNull byte[] data, long interval) {

        if (!checkValid()) {
            showToast("请检查蓝牙连接状态");
            LogUtil.d("Write Invalid");
            return;
        }
        if (data.length == 0) {
            showToast("发送内容为空");
            return;
        }
        if (type == SendType.TYPE_SINGLE) {
            LogUtil.d("singleWrite");
            singleTask = new SingleTask(this);
            singleTask.execute(new BytesTaskBean(data));
        } else if (type == SendType.TYPE_CYCLIC || type == SendType.TYPE_TIMING) {
            timingTask = new TimingTask(this);
            timingTask.execute(new BytesTaskBean(data, interval));
        } else {
            LogUtil.d("unknown write type");
        }
    }

    /**
     * 发送文件
     *
     * @param file
     */
    void write(@NonNull File file) {
        if (!checkValid()) {
            showToast("请检查蓝牙连接状态");
            LogUtil.d("Write Invalid");
            return;
        }
        if (!file.exists()) {
            showToast("待发送的文件不存在");
            LogUtil.d("待发送的文件不存在");
            return;
        }
        fileTask = new FileTak(this);
        fileTask.execute(new FileTaskBean(file));
    }

    /**
     * 取消发送
     */
    void cancel() {
        //写取消
        CH9140BluetoothManager.getInstance().stopWrite();
        if (singleTask != null && singleTask.getStatus() == AsyncTask.Status.RUNNING) {
            singleTask.cancel(true);
        } else if (fileTask != null && fileTask.getStatus() == AsyncTask.Status.RUNNING) {
            fileTask.cancel(true);
        } else if (timingTask != null && timingTask.getStatus() == AsyncTask.Status.RUNNING) {
            timingTask.cancel(true);
        }
    }

    private boolean isRunningSendTask() {
        if (singleTask != null && singleTask.getStatus() == AsyncTask.Status.RUNNING) {
            return true;
        } else if (fileTask != null && fileTask.getStatus() == AsyncTask.Status.RUNNING) {
            return true;
        } else if (timingTask != null && timingTask.getStatus() == AsyncTask.Status.RUNNING) {
            return true;
        }
        return true;
    }

    private void clearWrite() {

        count_W = 0;
        tempCount_W = 0;
        speed_W = 0;
        sendData.setText("");
        sendCount.setText(count_W + " 字节");
    }

    private void initWriteData() {
        flag = false;
        count_W = 0;
        tempCount_W = 0;
        speed_W = 0;
        handler.post(new Runnable() {
            @Override
            public void run() {
                sendCount.setText(count_W + " 字节");
                sendSpeed.setText(speed_W + " 字节/秒");
            }
        });
    }

    void pickFile() {
        new LFilePicker()
                .withActivity(MainActivity.this)
                .withRequestCode(CODE_CHOOSE_FILE)
                .withStartPath(Environment.getExternalStorageDirectory().getAbsolutePath())//指定初始显示路径
                .withMaxNum(1)
                .withNotFoundBooks("请选择一个文件")
                .start();
    }

    void reModifySendStatus() {
        SendBean sendStatus = ConfigSaveUtil.getInstance().getSendStatus();
        if (sendStatus != null) {
            sendDesc.setText(sendStatus.toString());
            if (sendStatus.getType() == SendType.TYPE_FILE) {
                llProgress.setVisibility(View.GONE);
            } else {
                llProgress.setVisibility(View.GONE);
            }
        } else {
            LogUtil.d("获取到的发生状态信息为空");
        }
    }

    void updateValue(final int newCount) {
        count_W += newCount;
        handler.post(new Runnable() {
            @Override
            public void run() {
                LogUtil.d("发送总计："+count_W);
                sendCount.setText(count_W + " 字节");
            }
        });
    }

    /*void showSendInterruptDialog() {
        SendInterruptConfigDialog interruptConfigDialog = SendInterruptConfigDialog.newInstance(CH9140BluetoothManager.getInstance().isBluetoothFlowOpened());
        interruptConfigDialog.setCancelable(false);
        interruptConfigDialog.show(getSupportFragmentManager(), "SendInterruptConfigDialog");
    }*/

    void toOfficialWebsite() {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("http://www.wch.cn/products/category/63.html"));
        startActivity(intent);
    }

    @Override
    public void onPreExecute(SendType type) {
        /*if (type == SendType.TYPE_SINGLE) {
            write.setEnabled(false);
        } else {
            //长时间发送
            write.setText(Constant.STOP);
            if (type == SendType.TYPE_FILE) {
                progressValue.setText("0%");
                progress.setProgress(0);
            }
        }*/

        write.setText(Constant.STOP);
        if (type == SendType.TYPE_FILE) {
            progressValue.setText("0%");
            progress.setProgress(0);
        }

    }

    @Override
    public void onCount(int count) {
        updateValue(count);
    }

    //只用于文件
    @Override
    public void onProgress(long current, long total) {
        //updateProgress(current,total);

    }

    void updateProgress(long current, long total) {
        int i = (int) (current / total * 100);
        handler.post(new Runnable() {
            @Override
            public void run() {
                progress.setProgress(i);
                progressValue.setText(String.format(Locale.US, "%d %%", i));
            }
        });
    }

    @Override
    public void onCancel(SendType type) {
        /*if (type == SendType.TYPE_SINGLE) {
            write.setEnabled(true);
        } else {
            //长时间发送
            write.setText(Constant.SEND);
        }*/
        write.setText(Constant.SEND);
    }

    //只用于文件和单次发送
    @Override
    public void onResult(SendType type, boolean result) {
        LogUtil.d("发送结果：" + result);
        /*if (!result) {
            showToast("发送失败");
        }
        if (type == SendType.TYPE_SINGLE) {
            write.setEnabled(true);
        } else {
            //长时间发送
            write.setText(Constant.SEND);
        }*/
        if(type==SendType.TYPE_SINGLE || type==SendType.TYPE_FILE){
            if (!result) {
                showToast("发送未完成");
            }
            write.setText(Constant.SEND);
        }else if(type==SendType.TYPE_TIMING ) {
            write.setText(Constant.SEND);
        }
    }
    /////////////////////////////////////////接收数据////////////////////////////////////////

    private long count_R = 0;
    private long tempCount_R = 0;
    private long speed_R = 0;

    private File file = null;
    private FileOutputStream fos = null;

    /**
     * 初始化两个通知，即接收数据的通知和状态的通知
     */
    private void initNotifyCallback() {

        CH9140BluetoothManager.getInstance().registerSerialModemNotify(new ModemStatus() {
            @Override
            public void onNotify(boolean DCD, boolean RI, boolean DSR, boolean CTS) {
                updateModem(DCD, RI, DSR, CTS);
            }
        });

        charDetailsNotificationSwitcher.setOnCheckedChangeListener(new SwitchButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(SwitchButton view, boolean isChecked) {
                LogUtil.d("NotificationSwitcher: " + isChecked);
            }
        });

    }

    @Override
    protected void onSerialData(byte[] data) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                updateValueTextView(data);
            }
        });
    }

    private void updateValueTextView(final byte[] data) {
        if (data == null || data.length == 0) {
            return;
        }
        count_R += data.length;
        LogUtil.d("共接收到："+count_R);
        if (file != null && fos != null) {
            //保存至文件
            try {
                fos.write(data);
            } catch (IOException e) {
                e.printStackTrace();
            }
            handler.post(new Runnable() {
                @Override
                public void run() {
                    receiveCount.setText(count_R + " 字节");
                }
            });
            return;
        }
        handler.post(new Runnable() {
            @Override
            public void run() {
                receiveCount.setText(count_R + " 字节");
                if(saveType==SaveType.SHOW_SCREEN){
                    if (receiveData.getText().toString().length() >= 1500) {
                        receiveData.setText("");
                        receiveData.scrollTo(0, 0);
                    }
                }else if(saveType==SaveType.SHOW_SCREEN_NO_CLEAR){

                }else if(saveType==SaveType.SHOW_SCREEN_PAUSE){

                    return;
                }

                if (receiveHex.isChecked()) {
                    receiveData.append(FormatUtil.bytesToHexString(data));
                } else {
                    receiveData.append(new String(data));
                }

                int offset = receiveData.getLineCount() * receiveData.getLineHeight();
                //int maxHeight = usbReadValue.getMaxHeight();
                int height = receiveData.getHeight();
                //USBLog.d("offset: "+offset+"  maxHeight: "+maxHeight+" height: "+height);
                if (offset > height) {
                    //USBLog.d("scroll: "+(offset - usbReadValue.getHeight() + usbReadValue.getLineHeight()));
                    receiveData.scrollTo(0, offset - receiveData.getHeight() + receiveData.getLineHeight());
                }
            }
        });

    }

    void clearRead() {
        count_R = 0;
        tempCount_R = 0;
        speed_R = 0;
        receiveData.setText("");
        receiveCount.setText(count_R + " 字节");
        receiveData.scrollTo(0, 0);
    }

    private void initReadData() {
        count_R = 0;
        tempCount_R = 0;
        speed_R = 0;
        handler.post(new Runnable() {
            @Override
            public void run() {
                receiveCount.setText(count_R + " 字节");
                receiveSpeed.setText(speed_R + " 字节/秒");

                //清空modem状态
                cbDcd.setChecked(false);
                cbDsr.setChecked(false);
                cbCts.setChecked(false);
                cbRi.setChecked(false);
            }
        });
    }

    private void saveToFile(@NonNull File f) {
        LogUtil.d("try saveToFile: " + f.getAbsolutePath());
        if (!f.exists()) {
            try {
                f.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        //检查当前是否正处于保存至文件的状态
        //true
        if (file != null && fos != null) {

            //检查是否是同一个文件
            if (file.getAbsolutePath().equals(f.getAbsolutePath())) {
                //true
                LogUtil.d("同一个文件，无需更改");
                return;
            } else {
                //false,关闭当前文件
                LogUtil.d("不同一个文件，需先关闭");
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                try {
                    fos = new FileOutputStream(f);
                    file = f;
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }
            }
        } else {
            LogUtil.d("直接打开");
            file = f;
            try {
                fos = new FileOutputStream(f);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
        //ui更新
        llReceiveSave.setVisibility(View.VISIBLE);
        receiveDesc.setText("正保存至:" + f.getName());
    }

    private void showOnScreen() {
        llReceiveSave.setVisibility(View.GONE);
        receiveDesc.setText("");
        if (fos != null) {
            try {
                fos.close();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        fos = null;
        file = null;
    }

    void reModifySaveStatus() {
        SaveBean saveStatus = ConfigSaveUtil.getInstance().getSaveStatus();
        if (saveStatus != null) {
            saveType=saveStatus.getType();
            if (saveStatus.getType() == SaveType.SHOW_SCREEN
                    || saveStatus.getType() == SaveType.SHOW_SCREEN_NO_CLEAR
                    || saveStatus.getType() == SaveType.SHOW_SCREEN_PAUSE) {
                showOnScreen();
            } else if (saveStatus.getType() == SaveType.SAVE_FILE) {
                if (saveStatus.getFile() == null) {
                    LogUtil.d("不合法的字段，File不能为空");
                    return;
                }
                saveToFile(saveStatus.getFile());
            } else {
                LogUtil.d("未定义的接收类型");
            }
        }
    }

    /**
     * 防止fos未关闭
     */
    private void closeReceive() {
        if (fos != null) {
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        fos = null;
        file = null;
    }

    private void share(String message) {
        LogUtil.d("-------->尝试分享");
        if (file == null || fos == null) {
            return;
        }
        LogUtil.d("-------->开始分享");
        DialogUtil.getInstance().showSimpleDialog(this, message, new DialogUtil.IResult() {
            @Override
            public void onContinue() {
                //切换为实时显示
                llReceiveSave.setVisibility(View.GONE);
                receiveDesc.setText("");
                String p = file.getAbsolutePath();
                closeReceive();
                //底部菜单，选择通过微信或邮件
                showSnack(p);
            }

            @Override
            public void onCancel() {
                LogUtil.d("-------->取消分享");
            }
        });
    }

    /**
     * 分享当前接收数据区的数据
     */
    private void shareData(String message) {
        LogUtil.d("-------->尝试分享");
        String s = receiveData.getText().toString();
        if (TextUtils.isEmpty(s)) {
            showToast("当前接收的内容为空");
            return;
        }
        LogUtil.d("-------->开始分享");
        DialogUtil.getInstance().showSimpleDialog(this, message, new DialogUtil.IResult() {
            @Override
            public void onContinue() {
                //将数据保存至文件
                File dir = MyApplication.getContext().getExternalFilesDir(Constant.Folder);
                File log = new File(dir, FileUtil.getRandomName(address) + "_Screen.log");
                try {
                    if (!log.exists()) {
                        log.createNewFile();
                    }
                    FileUtil.writeDataToFile(s.getBytes(), log);
                    //底部菜单，选择通过微信或邮件
                    showSnack(log.getAbsolutePath());
                } catch (Exception e) {
                    showToast("分享失败");
                }
            }

            @Override
            public void onCancel() {
                LogUtil.d("-------->取消分享");
            }
        });
    }

    private void showSnack(String filePath) {
        //1、使用Dialog、设置style
        final Dialog dialog = new Dialog(this, R.style.DialogTheme);
        //2、设置布局
        View view = View.inflate(this, R.layout.dialog_snack, null);
        dialog.setContentView(view);

        Window window = dialog.getWindow();
        //设置弹出位置
        window.setGravity(Gravity.BOTTOM);
        //设置弹出动画
        window.setWindowAnimations(R.style.main_menu_animStyle);
        //设置对话框大小
        window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.show();
        dialog.findViewById(R.id.sb_email).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
                AppUtil.sendTxt(MainActivity.this, filePath, "蓝牙文件");
            }
        });
        dialog.findViewById(R.id.sb_sns).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
                AppUtil.shareTxt(MainActivity.this, filePath);
            }
        });
        dialog.findViewById(R.id.sb_cancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
            }
        });
    }

    /**
     * 同步软件与硬件配置，包括波特率和Modem流控，用于连接蓝牙后同步
     */
    public void syncSerialStatus(SerialBaudBean baudBean, SerialModemBean modemBean) {
        LogUtil.d("同步参数");
        Observable.create(new ObservableOnSubscribe<String>() {

            @Override
            public void subscribe(ObservableEmitter<String> emitter) throws Exception {

                boolean b = CH9140BluetoothManager.getInstance().setSerialBaud(baudBean.getBaud(), baudBean.getData(), baudBean.getStop(), baudBean.getParity());

                if(!b){
                    emitter.onError(new Throwable("set baud fail"));
                    return;
                }
                boolean b1 = CH9140BluetoothManager.getInstance().setSerialModem(modemBean.isFlow(), modemBean.getDTR(), modemBean.getRTS());
                if(!b1){
                    emitter.onError(new Throwable("set flow and modem fail"));
                    return;
                }

                emitter.onComplete();

            }
        })
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        DialogUtil.getInstance().showLoadingDialog(MainActivity.this, "正在同步参数");
                    }

                    @Override
                    public void onNext(String s) {

                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtil.d(e.getMessage());
                        showToast("同步参数失败");
                        DialogUtil.getInstance().hideLoadingDialog();
                    }

                    @Override
                    public void onComplete() {
                        DialogUtil.getInstance().hideLoadingDialog();
                        showToast("同步参数成功");
                        updateSerialInfo();
                        updateRTSStatus();
                    }
                });
    }

    /**
     * 设置Modem状态
     */
    public void setModem( SerialModemBean modemBean) {
        Observable.create(new ObservableOnSubscribe<String>() {

            @Override
            public void subscribe(ObservableEmitter<String> emitter) throws Exception {
                boolean b1 = CH9140BluetoothManager.getInstance().setSerialModem(modemBean.isFlow(), modemBean.getDTR(), modemBean.getRTS());
                if(!b1){
                    emitter.onError(new Throwable("set flow and modem fail"));
                    return;
                }
                emitter.onComplete();
            }
        })
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        DialogUtil.getInstance().showLoadingDialog(MainActivity.this, "设置参数");
                    }

                    @Override
                    public void onNext(String s) {

                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtil.d(e.getMessage());
                        showToast("设置失败");
                        DialogUtil.getInstance().hideLoadingDialog();
                    }

                    @Override
                    public void onComplete() {
                        DialogUtil.getInstance().hideLoadingDialog();
                        showToast("设置成功");
                        ConfigSaveUtil.getInstance().getSerialStatusBean().setSerialModemBean(modemBean);
                        updateSerialInfo();
                        updateRTSStatus();
                    }
                });
    }

    /**
     * 设置串口波特率相关
     *

     * @param data
     */
    public void setSerial(SerialBaudBean data) {
        Observable.create(new ObservableOnSubscribe<String>() {

            @Override
            public void subscribe(ObservableEmitter<String> emitter) throws Exception {
                boolean b = CH9140BluetoothManager.getInstance().setSerialBaud(data.getBaud(), data.getData(), data.getStop(), data.getParity());

                if(!b){
                    emitter.onError(new Throwable("set baud fail"));
                    return;
                }
                emitter.onComplete();

            }
        })
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        DialogUtil.getInstance().showLoadingDialog(MainActivity.this, "设置参数");
                    }

                    @Override
                    public void onNext(String s) {

                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtil.d(e.getMessage());
                        showToast("设置失败");
                        DialogUtil.getInstance().hideLoadingDialog();
                    }

                    @Override
                    public void onComplete() {
                        DialogUtil.getInstance().hideLoadingDialog();
                        showToast("设置成功");
                        ConfigSaveUtil.getInstance().getSerialStatusBean().setSerialBaudBean(data);
                        updateSerialInfo();
                        updateRTSStatus();
                    }
                });

    }

    private void updateSerialInfo(){
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                SerialBaudBean serialBaudBean = ConfigSaveUtil.getInstance().getSerialStatusBean().getSerialBaudBean();
                SerialModemBean serialModemBean = ConfigSaveUtil.getInstance().getSerialStatusBean().getSerialModemBean();
                if(serialBaudBean!=null && serialModemBean!=null){
                    serialInfo.setText(serialBaudBean.toString()+" "+serialModemBean.toString());
                }

            }
        });
    }

    //当流控开启时，需要禁用RTS
    private void updateRTSStatus(){
        SerialModemBean serialModemBean = ConfigSaveUtil.getInstance().getSerialStatusBean().getSerialModemBean();
        if(serialModemBean!=null){
            boolean flow = serialModemBean.isFlow();
            if(dialog!=null && dialog.isVisible()){
                dialog.updateRSTStatus(flow);
            }
        }
    }

    //初次连接后将MTU置为最大
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void syncMtu(){
        handler.post(new Runnable() {
            @Override
            public void run() {
                setMtu(247);
            }
        });
    }

    /*//用作测试RSSI读取，定时器需要取消
    void testRSSI(){
        CH9140BluetoothManager.getInstance().registerRSSINotify(new RSSIStatus() {
            @Override
            public void onRSSI(int rssi, int status) {
                LogUtil.d("RSSI: "+rssi);
            }
        });
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(3);
        scheduledExecutorService.scheduleWithFixedDelay(new Runnable() {
            @Override
            public void run() {
                LogUtil.d("read :"+ CH9140BluetoothManager.getInstance().readRSSI());

            }
        },200,1000, TimeUnit.MILLISECONDS);
    }*/
}