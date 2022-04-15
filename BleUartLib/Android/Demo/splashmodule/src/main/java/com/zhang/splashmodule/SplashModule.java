package com.zhang.splashmodule;

import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

public class SplashModule {


    private static Class<? extends AppCompatActivity> homeActivity=null;
    private static PresentRuler presentRuler;

    /**
     * 初始化，设置显示规则，以及主页
     * @param ruler
     * @param activity
     */
    public static void init(@NonNull PresentRuler ruler,@NonNull Class<? extends AppCompatActivity> activity){
        presentRuler=ruler;
        homeActivity=activity;
    }

    public static PresentRuler getPresentRuler() {
        return presentRuler;
    }

    public static Class<? extends AppCompatActivity> getHomeActivity() {
        return homeActivity;
    }
}
