package cn.wch.ch9140uart;

import android.app.Application;

import com.zhang.splashmodule.PresentRuler;
import com.zhang.splashmodule.SplashModule;

import cn.wch.ch9140lib.CH9140BluetoothManager;
import cn.wch.ch9140lib.exception.CH9140LibException;
import cn.wch.ch9140lib.utils.LogUtil;
import cn.wch.ch9140uart.database.RoomUtil;

public class MyApplication extends Application {
    private   static MyApplication myApplication;
    @Override
    public void onCreate() {
        super.onCreate();
        myApplication=this;
        RoomUtil.getInstance().init(this);
        PresentRuler presentRuler=new PresentRuler.Builder()
                .builder();
        SplashModule.init(presentRuler,MainActivity.class);
        //SplashModule.loadFromLocal(R.drawable.ic_logo_text);
        try {
            CH9140BluetoothManager.getInstance().init(this);
        } catch (CH9140LibException e) {
            e.printStackTrace();
            LogUtil.d(e.getMessage());
        }
    }

    public static MyApplication getContext(){
        return myApplication;
    }
}
