package com.zhang.splashmodule.util;

import android.content.Context;
import android.content.SharedPreferences;

import com.zhang.splashmodule.log.LogUtil;

public class SPUtil {

    private static String SP_NAME="Init";
    private static String TAG_FIRST="First";
    public static boolean isFirstRun(Context context){
        SharedPreferences sp=context
                .getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        boolean aBoolean = sp.getBoolean(TAG_FIRST, true);
        if(aBoolean){
            setFirstRun(context,false);
        }
        LogUtil.d("first run ? "+aBoolean);
        return aBoolean;
    }

    private static void setFirstRun(Context context,boolean isFirst){
        SharedPreferences sp=context
                .getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor=sp.edit();
        editor.putBoolean(TAG_FIRST,isFirst);
        editor.apply();
    }
}
