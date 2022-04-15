package cn.wch.ch9140uart.utils;

import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.RequiresApi;

public class Location {
    @RequiresApi(api = Build.VERSION_CODES.P)
    public static boolean isLocationEnable(Context context){

        LocationManager locationManager=(LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        if(locationManager==null){
            return false;
        }
        return locationManager.isLocationEnabled();
    }

    public static void requestLocationService(Context context){
        context.startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
    }
}
