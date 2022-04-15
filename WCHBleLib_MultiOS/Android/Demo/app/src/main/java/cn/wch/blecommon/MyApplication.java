package cn.wch.blecommon;

import android.app.Application;

import cn.wch.blelib.WCHBluetoothManager;
import cn.wch.blelib.exception.BLELibException;
import cn.wch.blelib.utils.LogUtil;

public class MyApplication extends Application {

    private   static MyApplication myApplication;

    @Override
    public void onCreate() {
        super.onCreate();
        myApplication=this;
        //SplashModule.loadFromLocal(R.drawable.ic_logo_text);
        try {
            WCHBluetoothManager.getInstance().init(this);
        } catch (BLELibException e) {
            e.printStackTrace();
            LogUtil.d(e.getMessage());
        }
    }

    public static MyApplication getContext(){
        return myApplication;
    }
}
