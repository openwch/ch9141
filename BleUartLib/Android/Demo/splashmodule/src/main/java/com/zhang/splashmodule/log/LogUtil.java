package com.zhang.splashmodule.log;

import android.util.Log;

public class LogUtil {
    private final static String TAG="splashModule";
    public static void d(String message){
        Log.d(TAG, message);
    }
}
